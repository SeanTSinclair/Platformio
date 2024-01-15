extends MeshInstance3D

# Export variables to make them editable in the editor
@export var top_radius = 20.0
@export var bottom_radius = 20.0
@export var height = 180.0
@export var radial_segments = 32

func _ready():
	# Create a CylinderMesh for the visual representation
	var cylinder_mesh = CylinderMesh.new()
	cylinder_mesh.top_radius = top_radius  # Outer radius
	cylinder_mesh.bottom_radius = bottom_radius  # Outer radius
	cylinder_mesh.height = height  # Height of the cylinder
	cylinder_mesh.radial_segments = radial_segments  # Smoothness of the cylinder
	self.mesh = cylinder_mesh

	# Create a StaticBody3D for collision
	var static_body = StaticBody3D.new()
	self.add_child(static_body)

	# Parameters for the collision shell
	var shell_thickness = 0.1  # Thickness of the shell
	var collision_radius = top_radius - shell_thickness  # Adjusted radius for collision shell

	# Create the collision shell
	for i in range(radial_segments):
		var angle = 2 * PI * i / radial_segments
		var x = cos(angle) * collision_radius  # Use adjusted radius here
		var z = sin(angle) * collision_radius  # Use adjusted radius here

		# Create a CollisionShape3D for this segment
		var collision_shape = CollisionShape3D.new()
		static_body.add_child(collision_shape)

		# Create a box shape for this segment of the shell
		var box_shape = BoxShape3D.new()
		box_shape.extents = Vector3(shell_thickness, height / 2, top_radius / radial_segments)
		
		# Rotate and position the box shape
		collision_shape.shape = box_shape
		collision_shape.rotation_degrees = Vector3(0, -rad_to_deg(angle), 0)
		collision_shape.position = Vector3(x, 0, z)

	# Set the collision layer and mask on the StaticBody3D
	static_body.collision_layer = 1  # Set the layer
	static_body.collision_mask = 1  # Set the mask to interact with layer 1

	# Create the CSGCombiner for hollow effect
	var csg_combiner = CSGCombiner3D.new()
	self.add_child(csg_combiner)
	
	# Create the outer CSGCylinder (same size as the MeshInstance3D cylinder)
	var outer_cylinder = CSGCylinder3D.new()
	outer_cylinder.radius = top_radius
	outer_cylinder.height = height
	csg_combiner.add_child(outer_cylinder)
	
	# Create the inner CSGCylinder (slightly smaller to make the cylinder hollow)
	var inner_cylinder = CSGCylinder3D.new()
	inner_cylinder.radius = top_radius * 0.9  # Smaller radius for hollow effect
	inner_cylinder.height = height
	inner_cylinder.operation = CSGShape3D.OPERATION_SUBTRACTION
	csg_combiner.add_child(inner_cylinder)
