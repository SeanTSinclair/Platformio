extends Node

@export var cylinder_move_distance := 90

var level_generator: LevelGenerator
var cylinder: Node3D

func _ready():
	level_generator = %LevelGenerator
	level_generator.connect("on_should_move_cylinder", _move_cylinder)
	cylinder = level_generator.GenerateCylinderObject()
	%Cylinder.add_child(cylinder)
	level_generator.GenerateNewPlatforms(20)
	
func _move_cylinder():
	cylinder.position.y -= cylinder_move_distance
	level_generator.GenerateNewPlatforms(20)

