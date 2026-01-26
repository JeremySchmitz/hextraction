extends Node3D
const NO_TILE := Vector2(-1, -1)
const MARBLE = preload("res://scenes/marble.tscn")

var tiles: Array[Array] = []
var selectedTile: Vector2 = NO_TILE


func _ready() -> void:
	SignalBus.tileClick.connect(_onTileClick)
	SignalBus.tileConfirmed.connect(_onTileSet)
	SignalBus.tileCanceled.connect(_onTileCanceled)
	SignalBus.startAreaClicked.connect(_onStartClick)
	SignalBus.tileCardClicked.connect(_onCardClicked)
	
	_getTilePlaces()
	_readyPlaces(false)
	
	for tile in TileDeck.TILE_LIST.values():
		%MultiplayerSpawner.add_spawnable_scene(tile.scenePath)

	Stack.deck = TileDeck.buildDeck(20)

func _onCardClicked(rsc: TileResource):
	Stack.selectedTile = TileDeck.TILE_LIST[rsc.tileType].scenePath
	pass

func setHasTile(pos: Vector2, val = true):
	_setHasTile(pos, val)
	rpc('_setHasTile', pos, val)

@rpc("any_peer")
func _setHasTile(pos: Vector2, val = true):
	_getTile(pos).hasTile = val

func readyPlaces():
	_readyPlaces(true)
	rpc('_readyPlaces', false)

@rpc("any_peer")
func _readyPlaces(tileSet: bool):
	for row in tiles:
		for newTile in row:
			(newTile as TilePlace).readyTile(tiles, tileSet)

func _unreadyPlaces():
	for row in tiles:
		for newTile in row:
			(newTile as TilePlace).selectable = false

func _onTileClick(pos: Vector2):
	if (!Stack.isTurn() || !Stack.selectedTile): return
	
	if (selectedTile != NO_TILE): _getTile(selectedTile).active = false
	_getTile(pos).active = true
	selectedTile = pos
	_unreadyPlaces()
	
func _onTileSet(pos: Vector3, rot: Vector3):
	_getTile(selectedTile).active = false
	setHasTile(selectedTile)
	readyPlaces()
	
	var selectedRSC = Stack.selectedTile
	if !multiplayer.is_server():
		rpc_id(1, "spawnTile", selectedRSC, pos, rot)
	else:
		spawnTile(selectedRSC, pos, rot)

	selectedTile = NO_TILE
	SignalBus.tilePlayed.emit(selectedRSC)

func _onTileCanceled(pos: Vector2):
	var newTile = _getTile(pos)
	newTile.active = false
	newTile.hidePreview()
	_readyPlaces(false)

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
	newTile.position = pos
	newTile.rotation = rot
	add_child(newTile, true)
	newTile.syncing()
