extends Node3D
const NO_TILE = Vector2(-1, -1)
const MARBLE = preload("res://scenes/marble.tscn")

var tiles: Array[Array] = []
var selectedTile: Vector2 = NO_TILE


func _ready() -> void:
	SignalBus.tileClick.connect(_onTileClick)
	SignalBus.tileConfirmed.connect(_onTileSet)
	SignalBus.tileCanceled.connect(_onTileCanceled)
	SignalBus.startClicked.connect(_onStartClick)
	
	Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.X]
	_getTilePlaces()
	_readyPlaces()

func _input(event: InputEvent) -> void:
	if (Input.is_key_pressed(KEY_1)):
		print('ASTERISK')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.ASTERISK]
	elif (Input.is_key_pressed(KEY_2)):
		print('BLIND_BOTTOM')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.BLIND_BOTTOM]
	elif (Input.is_key_pressed(KEY_3)):
		print('DC')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.DC]
	elif (Input.is_key_pressed(KEY_4)):
		print('DIC')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.DIC]
	elif (Input.is_key_pressed(KEY_5)):
		print('J')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.J]
	elif (Input.is_key_pressed(KEY_6)):
		print('PACHINKO')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.PACHINKO]
	elif (Input.is_key_pressed(KEY_7)):
		print('PEACE')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.PEACE]
	elif (Input.is_key_pressed(KEY_8)):
		print('TILE_TYPES')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.X]


func _readyPlaces():
	for row in tiles:
		for tile in row:
			(tile as tilePlace).readyTile()

func _unreadyPlaces():
	for row in tiles:
		for tile in row:
			(tile as tilePlace).selectable = false

func _onTileClick(pos: Vector2):
	if (selectedTile != NO_TILE): _getTile(selectedTile).active = false
	_getTile(pos).active = true
	selectedTile = pos
	_unreadyPlaces()
	
func _onTileSet():
	_getTile(selectedTile).active = false
	selectedTile = NO_TILE
	_readyPlaces()

func _onTileCanceled(pos: Vector2):
	var tile = _getTile(pos)
	tile.active = false
	tile.hidePreview()
	_readyPlaces()


func _onStartClick(pos: Vector3):
	var marble = MARBLE.instantiate()
	marble.position = pos
	add_child(marble)
	
func _getTilePlaces():
	var newTiles: Array[Array] = []
	for row in %grid.get_children():
		newTiles.append(row.get_children())
	tiles = newTiles

func _getTile(pos: Vector2) -> tilePlace:
	return tiles[pos.x][pos.y]


	pass # Replace with function body.
