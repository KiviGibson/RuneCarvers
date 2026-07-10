extends Resource
class_name Backpack

enum colors{green, blue, red}

@export var identity: colors
@export var passive: PackedScene
@export_multiline("desc") var description: String
