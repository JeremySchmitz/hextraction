extends Control

const TILE_CARD = preload("res://scenes/tile_card.tscn")

@export var cards: Array[TileResource] = []

func _ready() -> void:
	SignalBus.tilePlayed.connect(_onTilePlayed)
	SignalBus.tileDealt.connect(_onTileDealt)
	for rsc in cards:
		addCard(rsc)
		
func removeCard(i: int):
	var child = %handContainer.get_child(i)
	child.queue_free()
	
func addCard(rsc: TileResource):
	var card = TILE_CARD.instantiate()
	card.name = rsc.name
	card.tileResource = rsc
	%handContainer.add_child(card)

func _onTilePlayed(scenePath: String):
	var i = cards.find_custom(func(c): return c.scenePath == scenePath)
	if i == -1: return
	var card = cards[i]
	cards.remove_at(i)
	
	for child in %handContainer.get_children():
		if child.name == card.name:
			child.queue_free()
			break

func _onTileDealt(tile: TileResource):
	addCard(tile)
