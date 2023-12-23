extends Node

@export var cylinder_move_distance := 90

var level_generator: LevelGenerator
var has_entered_move_trigger: bool = false
var cylinder: Node3D

func _ready():
	cylinder = %Cylinder
	level_generator = %LevelGenerator
	level_generator.GenerateNewPlatforms(20)

func _on_area_3d_body_entered(body):
	if not has_entered_move_trigger:
		print("moving platform")
		cylinder.position.y -= cylinder_move_distance
		has_entered_move_trigger = true
		level_generator.GenerateNewPlatforms(20)

func _on_area_3d_body_exited(body):
	print("Body exited")
	has_entered_move_trigger = false


func _on_area_3d_area_entered(area):
	if not has_entered_move_trigger:
		print("moving platform")
		cylinder.position.y -= cylinder_move_distance
		has_entered_move_trigger = true
		level_generator.GenerateNewPlatforms(20)

func _on_area_3d_area_exited(area):
	print("Area exited")
	has_entered_move_trigger = false
