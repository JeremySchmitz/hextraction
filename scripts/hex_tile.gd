extends Node3D

@export var grid_position := Vector2.ZERO

const TILE_MATERIALS = [
	preload("res://resources/blue.tres"),
	preload("res://resources/green.tres"),
	preload("res://resources/red.tres"),
	preload("res://resources/yellow.tres"),
]


func _setMaterial(index: int):
	get_node("unit_hex/mergedBlocks(Clone)").material_override = _get_tile_material(index)

func _get_tile_material(tile_index: int):
	var index = tile_index % TILE_MATERIALS.size()
	return TILE_MATERIALS[index]

func _on_area_3d_mouse_entered() -> void:
	SignalBus.tileEntered.emit(grid_position)
	%unit_hex.show()
	#_setMaterial(1)


func _on_area_3d_mouse_exited() -> void:
	SignalBus.tileExited.emit(grid_position)
	%unit_hex.hide()
	#_setMaterial(0)


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if  Input.is_action_just_pressed("left_click"):
		SignalBus.tileClicked.emit(grid_position)
