extends Node2D
class_name Trader

@export var shop_tools: Array[Tool] # downloaded from npc !TEMPORARY 
@export var player_eq: Array[Tool] # downloaded from player !TEMPORARY

@export_group("Slots")
@export var shop_slots: Array[PathFollow2D]
@export var player_slots: Array[PathFollow2D]

var shop_cards: Array[ToolTrade]
var player_cards: Array[ToolTrade]
var currently_selected: Dictionary = {}
@export_group("Card")
@export_file("tscn") var card_scene: String

@export_group("Animation")
@export var first_point: PathFollow2D
@export var second_point: PathFollow2D
@export var path: Path2D
@export var animator: AnimationPlayer

var height: float = 270
var handle_distance: float = 100

func setup() -> void:
	for tool in shop_tools:
		var card: ToolTrade = load(card_scene).instantiate()
		card.tool = tool
		card.pos = len(shop_cards)
		card.is_owned_by_player = false
		self.add_child(card)
		card.global_position = shop_slots[len(shop_cards)].global_position
		shop_cards.append(card)
		card.picked.connect(get_input)
	var i: int = -1
	for tool in player_eq:
		i+=1
		if tool == null: 
			player_cards.append(null)
			continue
		var card: ToolTrade = load(card_scene).instantiate()
		card.tool = tool
		card.pos = i
		card.is_owned_by_player = true
		self.add_child(card)
		card.global_position = player_slots[i].global_position
		player_cards.append(card)
		card.picked.connect(get_input)



func _ready() -> void: setup()

func get_input(data: Dictionary) -> void:
	if currently_selected == {}: currently_selected = data
	elif data == currently_selected: currently_selected = {}
	else: swap(data)

func swap(data: Dictionary) -> void:
	var first_tool: ToolTrade
	var second_tool: ToolTrade
	# Setup animation curve
	if data["is_owned_by_player"]: 
		first_tool = player_cards[data["pos"]]
		path.curve.set_point_position(0, player_slots[data["pos"]].position)
	else: 
		first_tool = shop_cards[data["pos"]]
		path.curve.set_point_position(0, shop_slots[data["pos"]].position)
	if currently_selected["is_owned_by_player"]:
		second_tool = player_cards[currently_selected["pos"]]
		path.curve.set_point_position(1, player_slots[currently_selected["pos"]].position)
	else:
		second_tool = shop_cards[currently_selected["pos"]]
		path.curve.set_point_position(1, shop_slots[currently_selected["pos"]].position)
	# Preset points for aniamtion
	first_point.progress_ratio = 0.0
	second_point.progress_ratio = 1.0
	# Add then to curve for animation time
	first_tool.reparent(first_point)
	second_tool.reparent(second_point)
	animator.play("swap")
	
	# Set values
	if second_tool.is_owned_by_player: player_cards[second_tool.pos] = first_tool
	else: shop_cards[second_tool.pos] = first_tool
	
	if first_tool.is_owned_by_player: player_cards[first_tool.pos] = second_tool
	else: shop_cards[first_tool.pos] = second_tool
	
	first_tool.is_owned_by_player = second_tool.is_owned_by_player
	second_tool.is_owned_by_player = data["is_owned_by_player"]
	
	first_tool.pos = second_tool.pos
	second_tool.pos = data["pos"]
	
	currently_selected = {}

# Sets elements to not follow set path and stayin designated place
func back_to_me() -> void:
	first_point.get_child(0).reparent(self)
	second_point.get_child(0).reparent(self)

# Funkcje pozyskujące oraz wysyłające aktualny stan trade
func set_plyer_tools(player_eq:Array[Tool], player_backpack: Array[Tool]) -> void: pass

func set_trader_tools(trader_tools: Array[Tool]) -> void: shop_tools = trader_tools
	

func get_player_tools() -> Array[Tool]:
	var res: Array[Tool]
	for trade in player_cards:
		if trade == null: res.append(null)
		else: res.append(trade.tool)
	return res
	
func get_trader_tools() -> Array[Tool]: 
	var res: Array[Tool]
	for trade in shop_cards:
		if trade == null: continue
		res.append(trade.tool)
	return res
