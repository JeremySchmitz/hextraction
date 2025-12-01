extends Node3D
class_name tilePlace

@export var grid_position := Vector2.ZERO

const TILE_MATERIALS = [
	preload("res://resources/blue.tres"),
	preload("res://resources/green.tres"),
	preload("res://resources/red.tres"),
	preload("res://resources/yellow.tres"),
]

# If tile is currently being set
var active = false:
	set(val):
		active = val
		%icons.visible = val

var selectable = false

func readyTile():
	var hasTile = %markerTile.get_child_count() == 1
	selectable = !hasTile

func _setMaterial(index: int):
	get_node("highlight_hex").material_override = _get_tile_material(index)

func _get_tile_material(tile_index: int):
	var index = tile_index % TILE_MATERIALS.size()
	return TILE_MATERIALS[index]
	
func hidePreview():
	%highlight_hex.hide()
	if (!active && %markerTile.get_child_count() > 0):
		var child = %markerTile.get_child(0)
		if (child):
			%markerTile.remove_child(child)
			child.queue_free()

func _on_area_3d_mouse_entered() -> void:
	if (!selectable): return
	SignalBus.tileEntered.emit(grid_position)
	%highlight_hex.show()
	var preview: tile = load(Stack.selectedTile).instantiate()
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
			var pos = child.global_position
			var rot = child.global_rotation
			SignalBus.tileConfirmed.emit(pos, rot)
