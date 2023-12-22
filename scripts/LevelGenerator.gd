extends Node

var platform_scene := preload("res://objects/platform.tscn")
var vertical_offset := 10

var min_offset_x := -10
var min_offset_z := -10
var max_offset_x := 10
var max_offset_z := 10

var amount_created := 0

func AddHorizontalOffsetToVector(vector):
	var offset_x := randf_range(min_offset_x, max_offset_x)
	var offset_z := randf_range(min_offset_z, max_offset_z)
	
	var final_vector := Vector3(offset_x, vector.y, offset_z)
	return final_vector
	
func PlacePlatform(platform):
	# Calculate position of platform
	var platform_position := Vector3(0, (vertical_offset*amount_created)*-1, 0)
	
	# Do not add horizontal offset if it is the first one as the player spawns in the center.
	if amount_created != 0:
		platform_position = AddHorizontalOffsetToVector(platform_position)
		
	# Move and rotate platform. 
	platform.position = platform_position
	platform.rotate_y(randf_range(-360, 360))

func GenerateNewPlatforms(amount: int):
	for i in range(amount):
		# Create the platform
		var platform = platform_scene.instantiate()
		get_parent().add_child.call_deferred(platform)
		
		PlacePlatform(platform)
		
		amount_created += 1

func _ready():
	GenerateNewPlatforms(10)

func _on_area_3d_body_entered(body):
	print("Oh no")
	GenerateNewPlatforms(10)
