extends Node3D
class_name TilePlace

@export var grid_position := Vector2.ZERO
@export var board_size := Vector2(5, 4)
@export var starter_tile := false

const TILE_MATERIALS = [
	preload("res://resources/blue.tres"),
	preload("res://resources/green.tres"),
	preload("res://resources/red.tres"),
	preload("res://resources/yellow.tres"),
]

var adjacentTiles: PackedVector2Array = []
var hasTile := false

# If Tile is currently being set
var active = false:
	set(val):
		active = val
		%icons.visible = val

var selectable = false:
	set(val):
		selectable = val
		if (selectable): %highlight_hex.show()
		else: %highlight_hex.hide()

func _ready() -> void:
	_buildAdjacentTiles()

func hasPreview():
	return %markerTile.get_child_count() == 1

func readyTile(tiles: Array[Array]):
	if (hasTile):
		selectable = false
	elif (starter_tile):
		selectable = true
	else:
		for pos in adjacentTiles:
			var t = tiles[int(pos.x)][int(pos.y)]
			if (t.hasTile):
				selectable = true
				break
			else: selectable = false


func _setMaterial(index: int):
	get_node("highlight_hex").material_override = _get_tile_material(index)

func _get_tile_material(tile_index: int):
	var index = tile_index % TILE_MATERIALS.size()
	return TILE_MATERIALS[index]
	
func hidePreview():
	# %highlight_hex.hide()
	if (!active && %markerTile.get_child_count() > 0):
		var child = %markerTile.get_child(0)
		if (child):
			%markerTile.remove_child(child)
			child.queue_free()

func _on_area_3d_mouse_entered() -> void:
	if (!Stack.gameStarted
		|| !Stack.isTurn()
		|| !selectable
		|| !Stack.selectedTile
	): return

	SignalBus.tileEntered.emit(grid_position)
	# %highlight_hex.show()
	var preview: Tile = load(Stack.selectedTile).instantiate()
	if (preview.synschronizer):
		preview.synschronizer.public_visibility = false
	%markerTile.add_child(preview)
	#_setMaterial(1)


func _on_area_3d_mouse_exited() -> void:
	if (!selectable): return
	SignalBus.tileExited.emit(grid_position)
	hidePreview()
	#_setMaterial(0)


func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if (!selectable): return
	
	if (event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	):
		SignalBus.tileClick.emit(grid_position)


func _on_rotate_left_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if (event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	):
		%markerTile.rotate(Vector3(0, 1, 0), deg_to_rad(-60))


func _on_rotate_right_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if (event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	):
		%markerTile.rotate(Vector3(0, 1, 0), deg_to_rad(60))


func _on_cancel_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if (event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	):
		SignalBus.tileCanceled.emit(grid_position)


func _on_confirm_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if (event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	):
		var child = %markerTile.get_children()[0]
		if child:
			child.queue_free()
			var pos = global_position
			var rot = global_rotation
			hasTile = true
			SignalBus.tileConfirmed.emit(pos, rot)


func _buildAdjacentTiles():
	adjacentTiles = []
	var t: PackedVector2Array = []
	var x = int(grid_position.x)
	var y = int(grid_position.y)
	
	if (x % 2 == 0):
		t.append(Vector2(x - 1, y))
		t.append(Vector2(x - 1, y + 1))
		t.append(Vector2(x, y - 1))
		t.append(Vector2(x, y + 1))
		t.append(Vector2(x + 1, y))
		t.append(Vector2(x + 1, y + 1))
	else:
		t.append(Vector2(x - 1, y - 1))
		t.append(Vector2(x - 1, y))
		t.append(Vector2(x, y - 1))
		t.append(Vector2(x, y + 1))
		t.append(Vector2(x + 1, y - 1))
		t.append(Vector2(x + 1, y))

	for a in t:
		if (a.x >= 0 and a.y >= 0):
			if (a.x < board_size.x):
				if (int(a.x) % 2 == 0):
					if (a.y < board_size.y):
						adjacentTiles.append(a)
				else:
					if (a.y < board_size.y + 1):
						adjacentTiles.append(a)
