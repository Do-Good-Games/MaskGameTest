class_name BobbyCharacter extends CharacterBody2D

#const Throwable: PackedScene = preload("res://BobbyFolder/throwable.tscn")
@export var Throwable: PackedScene

@export var max_vel := 200.0
@export var friction := 0.01
@export var acceleration := 0.1
@export var throw_speed_scaling := 3
@export var throw_speed_max := 200

var throwing = false

var throwSpeed = 0

func get_move_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	if Input.is_action_pressed("right_click"):
		throwSpeed += 3
	return input
	
func process_throwing():
	var in_hand_obj = game_manager.current_held._obj_ref
	var in_hand_obj_throwable = get_throwable_child(in_hand_obj)
	if(in_hand_obj_throwable != null):
		if Input.is_action_just_pressed("left_click"):
			throwing = true
			# TODO deactivate inventory switching?
		if Input.is_action_pressed("left_click") && throwing:
			throwSpeed += throw_speed_scaling
			throwSpeed = min(throw_speed_max, throwSpeed)
		if Input.is_action_just_released("left_click"):
			in_hand_obj_throwable.speed = throwSpeed
			in_hand_obj.reactivate()
			throwing = false
			throwSpeed = 0
			# TODO reactive inventory switching?
	return
	
func get_throwable_child(parent):
	for n in parent.get_children():
		if n is Throwable:
			return n
	return null

func _physics_process(delta):
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
	
	# Throwing Code
	process_throwing()
	
	if( game_manager.current_held._item_type == game_manager.inventory_slot_type.LAMP):
		print ("player is carrying the lamp ", game_manager.current_held._color)
		draw_lantern()
		
	
	game_manager.playerx = self.position.x
	game_manager.playery = self.position.y

func draw_lantern():
	#mask : Sprite = new
	#if game_manager.current_held is game_manager.
	var curr_held :game_manager.InventorySlot = game_manager.current_held
	if curr_held._color == game_manager.color_enum.NONE:
		return
	var lamp : Lamp = curr_held._obj_ref as Lamp
	
	#duplicate lamp sprite 
	var sprite : Sprite2D = lamp.brush.duplicate()
	var gradientTex : GradientTexture2D = sprite.texture
	sprite.scale = sprite.scale * lamp.brush_scale
	#sprite.scale = sprite.scale.height * lamp.brush_scale
	#sprite.texture.resize(sprite.texture.get_width() * lamp.brush_scale, sprite.texture.get_height() * lamp.brush_scale)
	
	RoomManager.current_level.add_temp_mask(curr_held._color, sprite )

func _on_hitbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
