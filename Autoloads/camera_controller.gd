extends Node

@export var camera_depth: float  = 26


var scale_mtp = .01
var Cameras : Dictionary[GameManager.color_enum, Camera3D]

func set_camera_pos_init(new_pos_v2: Vector2):
	
	var new_pos_v3 = (Vector3(new_pos_v2.x * scale_mtp, camera_depth , new_pos_v2.y * scale_mtp))
	
	for key in Cameras.keys():
		print("pos ", str(Cameras[key].global_position))
		Cameras[key].global_position.x = new_pos_v3.x
		Cameras[key].global_position.z = new_pos_v3.z
		pass
	

func set_camera(color : GameManager.color_enum, camera :Camera3D):
	if(Cameras.has(color)):
		push_warning("camera controller is being asked to assign duplicate cameras for ", color)
		return
	Cameras[color] = camera
	
func usePlayer(player:BobbyCharacter):
	#player.make_canvas_position_local()
	pass
	

func update_cameras_v2(new_pos_v2: Vector2):
	#new_pos_v2.
	update_cameras_v3(Vector3(new_pos_v2.x * scale_mtp, camera_depth , new_pos_v2.y * scale_mtp))
	#update_cameras_v3(Vector3(new_pos_v2.x, new_pos_v2.y, camera_depth))
	pass

func update_cameras_v3(new_pos_v3: Vector3):
	print("updatingcameras to pos ", str(new_pos_v3))
	for key in Cameras.keys():
		print("pos ", str(Cameras[key].global_position))
		
		Cameras[key].h_offset = new_pos_v3.x
		Cameras[key].v_offset = -new_pos_v3.z
		
		#RoomManager.current_level.red_mask.
		
		#Cameras[key].global_position = new_pos_v3
		
		#Cameras[key].global_position = new_pos_v3
		
		#Cameras[key].global_position.x = new_pos_v3.x
		#Cameras[key].global_position.z = new_pos_v3.z
		pass
