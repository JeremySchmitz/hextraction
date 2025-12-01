extends Area3D
class_name goal

@export var settleTime := 5.0
var timer: Timer

func _ready() -> void:
	connect("body_shape_entered", _on_body_shape_entered)
	connect("body_shape_exited", _on_body_shape_exited)
	
	timer = Timer.new()
	timer.wait_time = settleTime
	timer.timeout.connect(_goal_reached)
	add_child(timer)


func _on_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int):
	if body.is_in_group('marble'):
		if timer.is_stopped(): timer.start()


func _on_body_shape_exited(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int):
	if body.is_in_group('marble'): timer.stop()


func _goal_reached():
	SignalBus.goalReached.emit()
