extends Node

@export var camera_depth: float  =10


var Cameras : Dictionary[GameManager.color_enum, Camera3D]

func set_camera(color : GameManager.color_enum, camera :Camera3D):
	if(Cameras.has(color)):
		push_warning("camera controller is being asked to assign duplicate cameras for ", color)
		return
	Cameras[color] = camera
	

func update_cameras_v2(new_pos_v2: Vector2):
	update_cameras_v3(Vector3(new_pos_v2.x, new_pos_v2.y, camera_depth))

func update_cameras_v3(new_pos_v3: Vector3):
	for key in Cameras.keys():
		print("updating " , key, " to pos ", str(new_pos_v3))
		Cameras[key].global_position = new_pos_v3
