extends Node
class_name StackingComponent

signal stacks_achived()
signal stacks_earned(val: int)

var current_stacks: int = 1
@export var required_stacks: int
@export var reset: bool

func stack() -> void:
	current_stacks += 1
	if current_stacks == required_stacks:
		stacks_achived.emit()
	if reset and current_stacks > required_stacks:
		current_stacks = 1
	if current_stacks <= required_stacks:
		stacks_earned.emit(current_stacks)
