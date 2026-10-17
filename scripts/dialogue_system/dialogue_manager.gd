extends Node

signal dialogue_started(path: String)
signal line_changed(line: DialogueLine)
signal dialogue_signal(signal_name: String)
signal dialogue_ended(path:String)

var variables: Dictionary = {}
var active: bool = false
var _lines: Dictionary = {}
var _current_id: String = ""

func is_active() -> bool: return(active)

func start_dialogue(npcName: String, start_id: String = "start") -> void:
	active = true
	var dial : String = "res://data/dialogues/"+npcName+".json"
	_lines = _load_dialogue(dial)
	if _lines.is_empty():
		push_error("DialogueManager: nie udało się wczytać dialogu z %s" % npcName)
		return
	dialogue_started.emit(dial)
	_goto(start_id)

func choose(choice_index: int) -> void:
	var line: DialogueLine = _lines.get(_current_id)
	if line == null or choice_index < 0 or choice_index >= line.choices.size():
		return
	var choice: Dictionary = line.choices[choice_index]
	if choice.has("set"):
		var to_set: Dictionary = choice["set"]
		for key in to_set.keys():
			variables[key] = to_set[key]
	_goto(choice.get("next", ""))


func advance() -> void:
	var line: DialogueLine = _lines.get(_current_id)
	if line == null:
		return
	if line.choices.is_empty():
		_goto(line.next_id)


func get_current_line() -> DialogueLine:
	return _lines.get(_current_id)


func _load_dialogue(json_path: String) -> Dictionary:
	var result: Dictionary = {}
	if not FileAccess.file_exists(json_path):
		push_error("DialogueManager: plik nie istnieje: %s" % json_path)
		return result

	var file := FileAccess.open(json_path, FileAccess.READ)
	var raw_text := file.get_as_text()
	file.close()

	var json := JSON.new()
	var err := json.parse(raw_text)
	if err != OK:
		push_error("DialogueManager: błąd JSON w linii %d: %s" % [json.get_error_line(), json.get_error_message()])
		return result

	var data: Dictionary = json.data
	for id in data.keys():
		var entry: Dictionary = data[id]
		var line := DialogueLine.new()
		line.id = id
		line.speaker = entry.get("speaker", "")
		line.text = entry.get("text", "")
		line.choices = entry.get("choices", [])
		line.next_id = entry.get("next", "")
		line.signal_name = entry.get("signal", "")
		line.condition = entry.get("condition", "")
		line.is_end = entry.get("end", false)
		result[id] = line
	return result


func _goto(id: String) -> void:
	if id == "" or not _lines.has(id):
		_end_dialogue()
		return
	var line: DialogueLine = _lines[id]
	if line.condition != "" and not _check_condition(line.condition):
		_goto(line.next_id)
		return
	_current_id = id
	if line.signal_name != "":
		dialogue_signal.emit(line.signal_name)
	if line.is_end:
		_end_dialogue()
		return
	line_changed.emit(line)

func _check_condition(cond: String) -> bool:
	if "==" in cond:
		var parts := cond.split("==")
		var key := parts[0].strip_edges()
		var expected := parts[1].strip_edges()
		var actual = variables.get(key, null)
		return str(actual).to_lower() == expected.to_lower()
	return bool(variables.get(cond.strip_edges(), false))

func _end_dialogue() -> void:
	_current_id = ""
	active = false
	dialogue_ended.emit()
