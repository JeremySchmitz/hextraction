extends Area3D

func _ready() -> void:
	connect("body_shape_entered", _on_body_shape_entered)

func _on_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int):
	if body.is_in_group('marble'):
		body.queue_free()
