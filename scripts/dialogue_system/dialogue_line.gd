class_name DialogueLine
extends Resource

@export var id: String = ""
@export var speaker: String = ""
@export_multiline var text: String = ""
@export var choices: Array = []
@export var next_id: String = ""
@export var signal_name: String = ""
@export var condition: String = ""

@export var is_end: bool = false
