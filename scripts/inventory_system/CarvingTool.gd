extends Resource
class_name CarvingTool

@export var rune: PackedScene
@export_multiline("desc") var description: String
@export var icon: CompressedTexture2D
@export var pattern: Array[int]
@export_range(0.0, 20.0) var cooldown: float
