extends Node2D
class_name Trader

@export var shop_tools: Array[Tool] # downloaded from npc !TEMPORARY 
@export var player_eq: Array[Tool] # downloaded from player !TEMPORARY

@export_group("Slots")
@export var shop_slots: Array[PathFollow2D]
@export var player_slots: Array[PathFollow2D]

var shop_cards: Array[ToolTrade]
var player_cards: Array[ToolTrade]
var currently_selected: ToolTrade

@export_group("Card")
@export_file("tscn") var card_scene: String

func setup() -> void:
	for tool in shop_tools:
		var card: ToolTrade = load(card_scene).instantiate()
		card.tool = tool
		card.pos = len(shop_cards)
		card.is_owned_by_player = false
		self.add_child(card)
		card.global_position = shop_slots[len(shop_cards)].global_position
		shop_cards.append(card)
	var i: int = -1
	for tool in player_eq:
		i+=1
		if tool == null: continue
		var card: ToolTrade = load(card_scene).instantiate()
		card.tool = tool
		card.pos = len(shop_cards)
		card.is_owned_by_player = false
		self.add_child(card)
		card.global_position = player_slots[i].global_position
		shop_cards.append(card)
		

func _ready() -> void: setup()


func set_plyer_tools() -> void: pass
func set_trader_tools() -> void: pass
