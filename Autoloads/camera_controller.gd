extends Node2D
const camera_depth: float  = 26

const world_width_meters = 44
const world_height_meters = 30

const camera_fov =  rad_to_deg( atan(camera_depth/world_height_meters))*2 

var scale_mtp = .01
#var scale_mtp_x = .01
var Cameras : Dictionary[GameManager.color_enum, Camera3D]



func _ready():
	scale_mtp =  (world_height_meters/2)/ (get_viewport_rect().size.y)
	#scale_mtp_x =  (world_width_meters/2)/ (get_viewport_rect().size.x)
	print("scale is " , scale_mtp)
	print(" vp rect size is " , get_viewport_rect().size.y/2)
	print("fov is ", camera_fov)
	print()
	#scale_mtp = .01


func set_camera_pos_init(new_pos_v2: Vector2):
	
	
	for key in Cameras.keys():
		update_cameras_v2(new_pos_v2)
		#Cameras[key].global_position.x = new_pos_v3.x
		#Cameras[key].global_position.z = new_pos_v3.z
		pass
	

func set_camera(color : GameManager.color_enum, camera :Camera3D):
	if(Cameras.has(color)):
		push_warning("camera controller is being asked to assign duplicate cameras for ", color)
		return
	camera.position.y = camera_depth
	camera.fov = camera_fov
	print("fov is ", camera_fov)
	Cameras[color] = camera
	
func usePlayer(player:BobbyCharacter):
	#player.make_canvas_position_local()
	pass
	

func update_cameras_v2(new_pos_v2: Vector2):
	var rect  = get_viewport_rect().size
	var add = rect
	
	var new_x = lerp(-world_width_meters,world_width_meters, 
		new_pos_v2.x/rect.x)
	
	var new_z = lerp(-world_height_meters, world_height_meters, 
		new_pos_v2.y/rect.y)
	#var new_x = (new_pos_v2.x ) * scale_mtp
	#var new_z = (new_pos_v2.y ) * scale_mtp
	update_cameras_v3(Vector3(new_x, camera_depth , new_z))
	pass

func update_cameras_v3(new_pos_v3: Vector3):
	print("updating camera pos to ", new_pos_v3)
	for key in Cameras.keys():
		
		Cameras[key].h_offset = new_pos_v3.x
		Cameras[key].v_offset = -new_pos_v3.z
		
		#Cameras[key].position.x = new_pos_v3.x
		#Cameras[key].position.z = new_pos_v3.z
		#Cameras[key].position = new
		
		#RoomManager.current_level.red_mask.
		
		#Cameras[key].global_position = new_pos_v3
		
		#Cameras[key].global_position = new_pos_v3
		
		#Cameras[key].global_position.x = new_pos_v3.x
		#Cameras[key].global_position.z = new_pos_v3.z
		pass
