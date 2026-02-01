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
	return input
	
func process_throwing():
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
			throwing = false
			throwSpeed = 0
			# TODO reactive inventory switching?
	return
	
func get_throwable_child(parent) -> Throwable:
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

	
	
		
	
	game_manager.playerx = self.position.x
	game_manager.playery = self.position.y


func _on_hitbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
