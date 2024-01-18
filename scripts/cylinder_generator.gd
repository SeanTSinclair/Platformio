extends MeshInstance3D

@export var cylinder_radius = 20.0
@export var height = 180.0
@export var radial_segments = 32
@export var wall_thickness = 1

func _ready():
	create_visual_cylinder()
	create_collision_wall()
	create_hollow_effect()

# Creates the visual representation of the cylinder
func create_visual_cylinder():
	var cylinder_mesh = CylinderMesh.new()
	cylinder_mesh.top_radius = cylinder_radius + wall_thickness
	cylinder_mesh.bottom_radius = cylinder_radius + wall_thickness
	cylinder_mesh.height = height
	cylinder_mesh.radial_segments = radial_segments
	self.mesh = cylinder_mesh

# Creates a wall of collision boxes around the cylinder
func create_collision_wall():
	var static_body = StaticBody3D.new()
	add_child(static_body)

	var segment_width = 2 * PI * cylinder_radius / radial_segments  # Calculate the width of each segment

	for i in range(radial_segments):
		var angle = 2 * PI * i / radial_segments
		var x = cos(angle) * cylinder_radius
		var z = sin(angle) * cylinder_radius

		var collision_shape = CollisionShape3D.new()
		var box_shape = BoxShape3D.new()
		box_shape.extents = Vector3(wall_thickness / 2, height / 2, segment_width / 2)
		collision_shape.shape = box_shape

		collision_shape.rotation_degrees = Vector3(0, -rad_to_deg(angle), 0)
		collision_shape.position = Vector3(x, 0, z)

		static_body.add_child(collision_shape)

	static_body.collision_layer = 1
	static_body.collision_mask = 1

# Creates the hollow effect using CSGShapes
func create_hollow_effect():
	var csg_combiner = CSGCombiner3D.new()
	add_child(csg_combiner)

	var outer_cylinder = CSGCylinder3D.new()
	outer_cylinder.radius = cylinder_radius
	outer_cylinder.height = height
	csg_combiner.add_child(outer_cylinder)

	var inner_cylinder = CSGCylinder3D.new()
	inner_cylinder.radius = cylinder_radius
	inner_cylinder.height = height
	inner_cylinder.operation = CSGShape3D.OPERATION_SUBTRACTION
	csg_combiner.add_child(inner_cylinder)
