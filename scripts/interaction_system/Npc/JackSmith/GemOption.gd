extends Control
class_name GemOption

signal selected(gem: Gem)
signal on_button_press(ordered: int)

var gem: Gem: ## set gem in gemoption and setup is finished
	set(value):
		set_tags(value)
		set_writing(value)
		gem = value

@export var tags: Dictionary[Gem.color, Control] = {}
@export var name_label: Label
@export var desc_label: RichTextLabel
@export var slot_num: int
@export var sloted: bool 

func button_pressed() -> void:
	if not sloted:
		server_side_button_pressed.rpc_id(1)
	else:
		on_button_press.emit(slot_num)

@rpc("any_peer", "call_local", "reliable")
func server_side_button_pressed() -> void:
	selected.emit(gem)

func set_tags(g: Gem) -> void:
	if g == null:
		for k in tags.keys():
			tags[k].visible = false
		return
	match g.gem_type:
		Gem.type.main, Gem.type.only:
			for k in tags.keys():
				if k == g.identity: tags[k].visible = true
				else: tags[k].visible = false
		Gem.type.except:
			for k in tags.keys():
				if k != g.identity: tags[k].visible = true
				else: tags[k].visible = false
		Gem.type.colorless:
			for k in tags.keys():
				tags[k].visible = true

func set_writing(g: Gem) -> void:
	if not name_label: return
	if g == null:
		name_label.text = "Empty Slot"
		desc_label.text = "[center]Here can be placed gem thats amplify your power by giving you passive benefits."
	else:
		name_label.text = str(g.resource_name)
		desc_label.text = "[center]" + g.description + "[/center]"
