@tool
class_name BobbyCharacter extends CharacterBody2D

#const Throwable: PackedScene = preload("res://BobbyFolder/throwable.tscn")
@export var Throwable: PackedScene

@export var max_vel := 200.0
@export var friction := 0.01
@export var acceleration := 0.1
@export var throw_speed_scaling := 1
@export var throw_speed_max := 100

var throwing = false

var curr_held_lamp

var throwSpeed = 0

@export_category("Camera Bounds")
@export var upper_left_cam_bound : Vector2 = Vector2(  -486, -864)
@export var lower_right_cam_bound :Vector2 = Vector2(486 ,864 )

@onready var _animated_sprite = $Sprite2D
@onready var camera_2d: Camera2D = $Camera2D

func ready():
	if Engine.is_editor_hint() :
		return
	CameraController.set_camera_pos_init(global_position)
	game_manager.player = self
	
	camera_2d.limit_top = upper_left_cam_bound.x
	camera_2d.limit_left = upper_left_cam_bound.y
	camera_2d.limit_bottom = lower_right_cam_bound.x
	camera_2d.limit_right = lower_right_cam_bound.y

func _draw() -> void:
	if Engine.is_editor_hint():
		#var gizmo :rect =
		var rect : RectangleShape2D
		
		
		#1     2
		
		#3     4
		
		
		#draw_line(upper_left_cam_bound + global_position, Vector2(upper_left_cam_bound.x, lower_right_cam_bound.y) + global_position, Color.YELLOW)
		#draw_line(upper_left_cam_bound + global_position, Vector2(upper_left_cam_bound.y, lower_right_cam_bound.x) + global_position, Color.YELLOW)
		#
		#draw_line(lower_right_cam_bound + global_position, Vector2(upper_left_cam_bound.x, lower_right_cam_bound.y) + global_position, Color.YELLOW)
		#draw_line(lower_right_cam_bound + global_position, Vector2(upper_left_cam_bound.y, lower_right_cam_bound.x) + global_position, Color.YELLOW)
		
		
		draw_line(upper_left_cam_bound,Vector2(upper_left_cam_bound.x, lower_right_cam_bound.y), Color.YELLOW)
		draw_line(upper_left_cam_bound, Vector2(lower_right_cam_bound.x, upper_left_cam_bound.y), Color.YELLOW)
		
		draw_line(lower_right_cam_bound,Vector2(upper_left_cam_bound.x, lower_right_cam_bound.y), Color.YELLOW)
		draw_line(upper_left_cam_bound, Vector2(lower_right_cam_bound.x, upper_left_cam_bound.y), Color.YELLOW)
		
		return
		

func _process(_delta):
	if Engine.is_editor_hint() :
		
		queue_redraw()
		return
	_animated_sprite.play("run")

func get_move_input():
	if Engine.is_editor_hint() :
		return
	
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input
	
func process_throwing():
	if Engine.is_editor_hint() :
		return
	
	var in_hand_obj = game_manager.current_held._obj_ref
	var in_hand_obj_throwable :Throwable = get_throwable_child(in_hand_obj)
	if(in_hand_obj_throwable != null):
		if Input.is_action_just_pressed("left_click"):
			throwing = true
			# TODO deactivate inventory switching?
		if Input.is_action_pressed("left_click") && throwing:
			throwSpeed += throw_speed_scaling
			throwSpeed = min(throw_speed_max, throwSpeed)
		if Input.is_action_just_released("left_click"):
			print("releasing")
			in_hand_obj_throwable.throwing = true
			in_hand_obj_throwable.speed = throwSpeed / 5
			var mp = get_global_mouse_position()
			var tp = (mp - global_position)
			in_hand_obj_throwable.target_pos = tp * 100
			print(mp)
			in_hand_obj.reactivate()
			if in_hand_obj is Lamp2D:
				in_hand_obj.turn_on_lamp()
			game_manager.remove_current_held()
			throwing = false
			throwSpeed = 0
			# TODO reactive inventory switching?
	return
	
func get_throwable_child(parent) -> Throwable:
	if Engine.is_editor_hint() :
		return
	
	if not is_instance_valid(parent):
		return
	for n in parent.get_children():
		if n is Throwable:
			return n
	return null

func _physics_process(delta):
	if Engine.is_editor_hint() :
		return
	
	# Looking Code
	look_at(get_global_mouse_position())
	# Movement Code
	#TODO Remove the throwing from get_input()
	var direction = get_move_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * max_vel, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
	
	#TODO: stop animation
		# Throwing Code
	process_throwing()
	if game_manager.current_held._item_type == game_manager.inventory_slot_type.LAMP and is_instance_valid(game_manager.current_held._obj_ref):
		game_manager.current_held._obj_ref.position = position
	
	var rect = Rect2(0,0, camera_2d.limit_right * 2, camera_2d.limit_bottom * 2)
	#CameraController.update_cameras_v2(camera_2d.offset)
	var look_at : Vector2 = position
	look_at.x = clamp(position.x, camera_2d.limit_left, camera_2d.limit_right)
	#print(" pos", position.x," ", camera_2d.limit_left," ", camera_2d.limit_right)
	look_at.y = clamp(position.y, camera_2d.limit_top, camera_2d.limit_bottom)
	
	CameraController.update_cameras_v2(global_position, look_at)
	#
	#if rect.has_point(position):
		#print(" found")
	#else :
		#print ("no")
		
	
	
	game_manager.playerx = self.position.x
	game_manager.playery = self.position.y


		
func _on_hitbox_area_entered(area: Area2D) -> void:
	if Engine.is_editor_hint() :
		return
	
	pass # Replace with function body.
