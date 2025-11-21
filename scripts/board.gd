extends Node3D
const NO_TILE = Vector2(-1,-1)

var tiles: Array[Array] = []
var selectedTile: Vector2 = NO_TILE


func _ready() -> void:
	SignalBus.tileClick.connect(_onTileClick)
	SignalBus.tileConfirmed.connect(_onTileSet)
	Stack.selectedTile = TileDeck.TILE_LIST[TileDeck.TILE_TYPES.X]
	_getTilePlaces()
	_readyPlaces()


func _readyPlaces():
	for row in tiles:
		for tile in row:
			(tile as tilePlace).readyTile()

func _unreadyPlaces():
	for row in tiles:
		for tile in row:
			(tile as tilePlace).selectable = false

func _onTileClick(pos:Vector2):
	if (selectedTile != NO_TILE): _getTile(selectedTile).active = false
	_getTile(pos).active = true
	selectedTile = pos
	_unreadyPlaces()
	
func _onTileSet():
	_getTile(selectedTile).active = false
	selectedTile = NO_TILE
	_readyPlaces()
	
func _getTilePlaces():
	var newTiles: Array[Array] = []
	for row in %grid.get_children():
		newTiles.append(row.get_children())
	tiles = newTiles

func _getTile(pos:Vector2) -> tilePlace:
	return tiles[pos.x][pos.y]
