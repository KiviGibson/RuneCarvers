extends Control
class_name GemOption

signal selected(gem: Gem)

var gem: Gem: ## set gem in gemoption and setup is finished
	set(value):
		set_tags(value)
		set_writing(value)
		gem = value
		
@export var tags: Dictionary[Gem.color, Control] = {}
@export var name_label: Label
@export var desc_label: RichTextLabel

func button_pressed() -> void:
	selected.emit(gem)

func set_tags(g: Gem) -> void:
	match g.gem_type:
		Gem.type.main, Gem.type.only:
			for k in tags.keys():
				if k == gem.identity: tags[k].visible = true
				else: tags[k].visible = false
		Gem.type.except:
			for k in tags.keys():
				if k != gem.identity: tags[k].visible = true
				else: tags[k].visible = false
		Gem.type.colorless:
			for k in tags.keys():
				tags[k].visible = true

func set_writing(g: Gem) -> void:
	if not name_label: return
	name_label.text = str(g.resource_name)
	desc_label.text = "[center]" + g.description + "[/center]"
