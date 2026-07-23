extends Resource
class_name Damage

enum type{normal, fire, electric}
var owner: Unit

@export var damage_type: type 
@export var value: int = 1
