extends Node

var platform_scene := preload("res://objects/platform.tscn")
var vertical_offset := 10

var min_offset_x := -10
var min_offset_z := -10
var max_offset_x := 10
var max_offset_z := 10

func AddHorizontalOffsetToVector(vector):
	var offset_x := randf_range(min_offset_x, max_offset_x)
	var offset_z := randf_range(min_offset_z, max_offset_z)
	
	var final_vector := Vector3(offset_x, vector.y, offset_z)
	return final_vector

func _ready():
	# Generate the first 10 platforms
	for i in range(10):
		var platform = platform_scene.instantiate()
		get_parent().add_child.call_deferred(platform)
		var platform_position := Vector3(0, (vertical_offset*i)*-1, 0)
		if i != 0:
			platform_position = AddHorizontalOffsetToVector(platform_position)
		platform.transform.origin = platform_position
		platform.rotate_y(randf_range(-360, 360))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
