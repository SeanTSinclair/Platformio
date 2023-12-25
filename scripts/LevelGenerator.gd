extends Node
class_name LevelGenerator

var platform_scene := preload("res://objects/platform.tscn")
signal on_should_move_cylinder

@export var vertical_offset := 10
@export var horizontal_offset := 10
@export var cylinder_height := 400
@export var cylinder_radius := 35
@export var cylinder_thickness := 0.2
@export var cylinder_sides := 32

var amount_created := 0
var spawned_platforms := []

func GenerateCylinderObject():
	#https://gamedevacademy.org/csgcylinder3d-in-godot-complete-guide/
	var cylinder = Node3D.new()
	
	# The physical shapes of the cylinder.
	var outer_cylinder = CSGCylinder3D.new()
	outer_cylinder.name = "outer_cylinder"
	var inner_cylinder = CSGCylinder3D.new()
	inner_cylinder.name = "inner_cylinder"
	# The collision shape of the cylinder.
	var collision_shape = CollisionShape3D.new()
	collision_shape.name = "collision_shape"
	var cylinder_shape = CylinderShape3D.new()
	# For moving the cylinder when the player enters the area.
	var move_area = Area3D.new()
	move_area.name = "move_area"
	var move_collider = CollisionShape3D.new()
	move_collider.name = "move_collider"
	var move_shape = CylinderShape3D.new()
	
	# Create the cylinder
	outer_cylinder.height = cylinder_height
	outer_cylinder.radius = cylinder_radius
	outer_cylinder.sides = cylinder_sides
	inner_cylinder.height = cylinder_height + cylinder_thickness  # Slightly taller for clean subtraction
	inner_cylinder.radius = cylinder_radius - cylinder_thickness  # Smaller radius for inner space
	inner_cylinder.sides = cylinder_sides
	inner_cylinder.operation = CSGShape3D.OPERATION_SUBTRACTION
	
	cylinder.add_child(outer_cylinder)
	outer_cylinder.add_child(inner_cylinder)
	
	cylinder_shape.height = inner_cylinder.height
	cylinder_radius = inner_cylinder.radius
	collision_shape.shape = cylinder_shape
	move_shape.height = 4
	move_shape.radius = cylinder_radius
	move_collider.shape = move_shape
	
	move_area.area_entered.connect(_on_area_entered)
	outer_cylinder.add_child(collision_shape)
	move_area.add_child(move_collider)
	cylinder.add_child(move_area)
	move_area.position.y = -90
	
	return cylinder

func _on_area_entered(area):
	on_should_move_cylinder.emit()

func AddRandomHorizontalOffsetToVector(vector):
	var offset_x := randf_range(horizontal_offset*-1, horizontal_offset)
	var offset_z := randf_range(horizontal_offset*-1, horizontal_offset)
	
	var final_vector := Vector3(offset_x, vector.y, offset_z)
	return final_vector
	
func PlacePlatform(platform):
	# Calculate position of platform
	var platform_position := Vector3(0, (vertical_offset*amount_created)*-1, 0)
	
	# Do not add horizontal offset if it is the first one as the player spawns in the center.
	if amount_created != 0:
		platform_position = AddRandomHorizontalOffsetToVector(platform_position)
		
	# Move and rotate platform. 
	platform.position = platform_position
	platform.rotate_y(randf_range(-360, 360))

func GenerateNewPlatforms(amount: int):
	for i in range(amount):
		# Create the platform
		var platform = platform_scene.instantiate()
		get_parent().add_child.call_deferred(platform)
		
		PlacePlatform(platform)
		spawned_platforms.append(platform)
		
		amount_created += 1
	if spawned_platforms.size() > 50:
		for i in range(10):
			spawned_platforms.pop_front().queue_free()
