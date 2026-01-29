extends Area3D
class_name goal

var marbleInGoal = false

func _ready() -> void:
	connect("body_shape_entered", _on_body_shape_entered)
	connect("body_shape_exited", _on_body_shape_exited)
	SignalBus.restartGame.connect(_on_restart_game)
	
func _on_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int):
	if body and body.is_in_group('marble'):
		marbleInGoal = true
		SignalBus.marbleInGoal.emit(marbleInGoal)


func _on_body_shape_exited(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int):
	if body and body.is_in_group('marble'):
		marbleInGoal = false
		SignalBus.marbleInGoal.emit(marbleInGoal)

func _on_restart_game():
	marbleInGoal = false
