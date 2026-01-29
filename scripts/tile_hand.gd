extends Control

const TILE_CARD = preload("res://scenes/tile_card.tscn")

@export var cards: Array[TileResource] = []

func _ready() -> void:
	SignalBus.tilePlayed.connect(_onTilePlayed)
	SignalBus.tileDealt.connect(_onTileDealt)
	SignalBus.clearHand.connect(_clearHand)
		
func removeCard(i: int):
	cards.remove_at(i)
	var child = %handContainer.get_child(i)
	child.queue_free()
	
func addCard(rsc: TileResource):
	var card = TILE_CARD.instantiate()
	card.name = rsc.name
	card.tileResource = rsc
	%handContainer.add_child(card)
	cards.append(rsc)

func _onTilePlayed(scenePath: String):
	var i = cards.find_custom(func(c): return c.scenePath == scenePath)
	if i == -1: return
	removeCard(i)
	cards.remove_at(i)
	
func _onTileDealt(tile: TileResource):
	addCard(tile)

func _clearHand():
	cards = []

	for child in %handContainer.get_children():
		child.queue_free()
