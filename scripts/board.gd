extends Node3D
const NO_TILE = Vector2(-1, -1)
const MARBLE = preload("res://scenes/marble.tscn")

var tiles: Array[Array] = []
var selectedTile: Vector2 = NO_TILE


func _ready() -> void:
	SignalBus.tileClick.connect(_onTileClick)
	SignalBus.tileConfirmed.connect(_onTileSet)
	SignalBus.tileCanceled.connect(_onTileCanceled)
	SignalBus.startAreaClicked.connect(_onStartClick)
	SignalBus.tileCardClicked.connect(_onCardClicked)
	
	Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.X].scenePath
	_getTilePlaces()
	_readyPlaces()
	
	for tile in TileDeck.TILE_LIST.values():
		%MultiplayerSpawner.add_spawnable_scene(tile.scenePath)

	Stack.deck = TileDeck.buildDeck(20)

func _input(_event: InputEvent) -> void:
	if (Input.is_key_pressed(KEY_1)):
		print('ASTERISK')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.ASTERISK].scenePath
	elif (Input.is_key_pressed(KEY_2)):
		print('BLIND_BOTTOM')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.BLIND_BOTTOM].scenePath
	elif (Input.is_key_pressed(KEY_3)):
		print('DC')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.DC].scenePath
	elif (Input.is_key_pressed(KEY_4)):
		print('DIC')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.DIC].scenePath
	elif (Input.is_key_pressed(KEY_5)):
		print('J')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.J].scenePath
	elif (Input.is_key_pressed(KEY_6)):
		print('PACHINKO')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.PACHINKO].scenePath
	elif (Input.is_key_pressed(KEY_7)):
		print('PEACE')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.PEACE].scenePath
	elif (Input.is_key_pressed(KEY_8)):
		print('TILE_TYPES')
		Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.X].scenePath

func _onCardClicked(rsc: TileResource):
	Stack.selectedTile = TileDeck.TILE_LIST[rsc.tileType].scenePath
	pass

func _readyPlaces():
	for row in tiles:
		for newTile in row:
			(newTile as TilePlace).readyTile()

func _unreadyPlaces():
	for row in tiles:
		for newTile in row:
			(newTile as TilePlace).selectable = false

func _onTileClick(pos: Vector2):
	if (selectedTile != NO_TILE): _getTile(selectedTile).active = false
	_getTile(pos).active = true
	selectedTile = pos
	_unreadyPlaces()
	
func _onTileSet(pos: Vector3, rot: Vector3):
	var selected = Stack.selectedTile
	_getTile(selectedTile).active = false
	selectedTile = NO_TILE
	_readyPlaces()
	if !multiplayer.is_server():
		rpc_id(1, "spawnTile", selected, pos, rot)
	else:
		spawnTile(selected, pos, rot)

	SignalBus.tilePlayed.emit(selected)

func _onTileCanceled(pos: Vector2):
	var newTile = _getTile(pos)
	newTile.active = false
	newTile.hidePreview()
	_readyPlaces()

func _onStartClick(pos: Vector3):
	if !multiplayer.is_server():
		rpc_id(1, "spawnMarble", pos)
	else:
		spawnMarble(pos)

	
func _getTilePlaces():
	var newTiles: Array[Array] = []
	for row in %grid.get_children():
		newTiles.append(row.get_children())
	tiles = newTiles

func _getTile(pos: Vector2) -> TilePlace:
	return tiles[pos.x][pos.y]

	
@rpc("any_peer")
func spawnMarble(pos: Vector3):
	var marble = MARBLE.instantiate()
	marble.name = str(randf())
	marble.position = pos
	add_child(marble)
	

@rpc("any_peer")
func spawnTile(tileRsc, pos: Vector3, rot: Vector3):
	var newTile = load(tileRsc).instantiate()
	print('pos:', pos)
	print('rot:', rot)
	newTile.position = pos
	newTile.rotation = rot
	add_child(newTile, true)
	newTile.syncing()
	Stack.nextTurn()
