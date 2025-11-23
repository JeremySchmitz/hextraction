extends Control

const TILE_CARD = preload("res://scenes/tile_card.tscn")

@export var cards: Array[TileResource]

func _ready() -> void:
	for rsc in cards:
		var card = TILE_CARD.instantiate()
		card.tileResource = rsc
		%handContainer.add_child(card)
