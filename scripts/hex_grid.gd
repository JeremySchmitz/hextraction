extends Node3D

const HEX_TILE = preload("res://scenes/hex_tile.tscn")
const TILE_MATERIALS = [
	preload("res://resources/blue.tres"),
	preload("res://resources/green.tres"),
	preload("res://resources/red.tres"),
	preload("res://resources/yellow.tres"),
]
@export var TILE_SIZE := 1.0
@export var GRID_SIZE := Vector2(5,4)

func _ready() -> void:
	_buildGrid()
	
	
func _buildGrid():
	var tile_index := 0
	for x in range(GRID_SIZE.x):
		var firstOrLast = x == 0 || x == GRID_SIZE.x - 1
		var coordinates = Vector2.ZERO
		coordinates.x = x * TILE_SIZE * cos(deg_to_rad(30))
		coordinates.y = 0 if x % 2 == 0 else TILE_SIZE / 2
		
		var rowHeight = GRID_SIZE.y
		if (firstOrLast):
			coordinates.y += TILE_SIZE
			rowHeight -= 1
			
		for y in range(rowHeight):
			var tile = HEX_TILE.instantiate()
			add_child(tile)
			tile.translate(Vector3(coordinates.x, 0, coordinates.y))
			#tile.get_node("unit_hex/mergedBlocks(Clone)").material_override = get_tile_material(tile_index)

			coordinates.y += TILE_SIZE
			tile_index += 1
			
func get_tile_material(tile_index: int):
	var index = tile_index % TILE_MATERIALS.size()
	return TILE_MATERIALS[index]
