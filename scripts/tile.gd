extends Node3D
class_name tile

var tileRotation := 0 :
	set(val):
		rotation.y = val
	get():
		return rotation.y
