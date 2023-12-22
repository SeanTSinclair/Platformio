extends CSGCylinder3D
class_name Platform

func Place(position: Vector3):
	get_parent_node_3d().position = position
