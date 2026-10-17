extends Control

const TYPEWRITER_CHARS_PER_SECOND := 40.0
const DEFAULT_PITCH_RANGE := Vector2(380.0, 500.0)
const SKIP_BLIP_FOR := " \n.,!?"

@onready var speaker_label: Label = $Panel/VBoxContainer/SpeakerLabel
@onready var dialogue_text: RichTextLabel = $Panel/VBoxContainer/DialogueText
@onready var choices_container: VBoxContainer = $Panel/VBoxContainer/ChoicesContainer
@onready var blip_player: AudioStreamPlayer = $BlipPlayer

var _typing := false
var _typing_cancelled := false
var _type_id := 0
var _current_pitch_range: Vector2 = DEFAULT_PITCH_RANGE


func _ready() -> void:
	hide()
	DialogueManager.line_changed.connect(_on_line_changed)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interaction"):
		if choices_container.get_child_count() == 0:
			DialogueManager.advance()


func _on_line_changed(line: DialogueLine) -> void:
	show()
	speaker_label.text = line.speaker
	speaker_label.visible = line.speaker != ""
	_clear_choices()
	_type_text(line.text)
	_show_choices(line.choices)


func _on_dialogue_ended() -> void:
	_type_id += 1
	_typing = false
	hide()


func _type_text(text: String) -> void:
	_type_id += 1
	var my_id := _type_id
	_typing = true
	_typing_cancelled = false
	dialogue_text.text = text
	dialogue_text.visible_characters = 0

	var delay := 1.0 / TYPEWRITER_CHARS_PER_SECOND

	for i in text.length():
		if my_id != _type_id:
			return
		if _typing_cancelled or not DialogueManager.is_active():
			blip_player.skip = true
			break

		dialogue_text.visible_characters = i + 1
		var current_char := text[i]
		if not SKIP_BLIP_FOR.contains(current_char):
			var freq: float = randf_range(_current_pitch_range.x, _current_pitch_range.y)
			blip_player.play_blip(freq)
		await get_tree().create_timer(delay).timeout

	if my_id != _type_id:
		return

	dialogue_text.visible_characters = -1
	_typing = false

func _skip_type_text() -> void:
	_typing_cancelled = true


func _show_choices(choices: Array) -> void:
	for i in choices.size():
		var choice: Dictionary = choices[i]
		var button := Button.new()
		button.text = choice.get("text", "")
		button.pressed.connect(_on_choice_pressed.bind(i))
		choices_container.add_child(button)


func _on_choice_pressed(index: int) -> void:
	DialogueManager.choose(index)


func _clear_choices() -> void:
	for child in choices_container.get_children():
		child.queue_free()
