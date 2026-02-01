class_name BobbyCharacter extends CharacterBody2D

#const Throwable: PackedScene = preload("res://BobbyFolder/throwable.tscn")
@export var Throwable: PackedScene

@export var max_vel := 200.0
@export var friction := 0.01
@export var acceleration := 0.1

var throwSpeed = 0

func get_input():
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
		
	if Input.is_action_just_released("right_click"):
		if(throwSpeed > 200):
			throwSpeed = 200
			

		var createdThrowable = Throwable.instantiate()
		get_tree().root.add_child(createdThrowable)
		createdThrowable.global_transform = self.global_transform
		createdThrowable.speed = throwSpeed
		throwSpeed = 0
	return input

func _physics_process(delta):
	look_at(get_global_mouse_position())
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * max_vel, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
	
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
	var lamp :Lamp = curr_held._obj_ref as Lamp
	
	#duplicate lamp sprite 
	var sprite : Sprite2D = lamp.brush.duplicate()
	var gradientTex : GradientTexture2D = sprite.texture
	sprite.scale = sprite.scale * lamp.brush_scale
	#sprite.scale = sprite.scale.height * lamp.brush_scale
	#sprite.texture.resize(sprite.texture.get_width() * lamp.brush_scale, sprite.texture.get_height() * lamp.brush_scale)
	
	RoomManager.current_level.add_temp_mask(curr_held._color, sprite )

func _on_hitbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
