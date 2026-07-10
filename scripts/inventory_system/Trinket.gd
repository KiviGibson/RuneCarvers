extends Resource
class_name Trinket

enum exception_type{colorless, except, only}

@export var color_identity: Backpack.colors
@export var type_of_identity: exception_type
@export var passive: PackedScene
@export_multiline("desc") var description: String

func is_included(backpack_identity: Backpack.colors) -> bool:
	match type_of_identity:
		exception_type.except:
			return color_identity != backpack_identity
		exception_type.only:
			return color_identity == backpack_identity
	return true
