extends Node3D
class_name start


func _on_start_01_input_event(camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if (_event is InputEventMouseButton
		and _event.button_index == MOUSE_BUTTON_LEFT
		and _event.pressed
	):
		SignalBus.startClicked.emit(%spawn.global_position)
