extends Resource
class_name Gem

enum color{green, blue, red}
enum type{main, colorless, except, only}

@export var identity: color
@export var gem_type: type
@export_file(".tscn") var passive: String
@export_multiline var description: String
