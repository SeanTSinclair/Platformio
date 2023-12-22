extends Node3D

var move_distance := 400

func _on_area_3d_body_entered(body):
	transform.origin.y -= move_distance
