extends Resource
class_name Damage

enum type{normal, fire, electric}

signal delt_damage(owner: Unit, prey: Unit, value: int)
var owner: Unit

@export var damage_type: type 
@export var value: int = 1
