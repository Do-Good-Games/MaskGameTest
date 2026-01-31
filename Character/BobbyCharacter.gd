extends CharacterBody2D

#const Throwable: PackedScene = preload("res://BobbyFolder/throwable.tscn")
@export var Throwable: PackedScene

@export var max_vel = 200
@export var friction = 0.01
@export var acceleration = 0.1

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
	if Input.is_action_pressed("click"):
		throwSpeed += 3
		
	if Input.is_action_just_released("click"):
		if(throwSpeed > 200):
			throwSpeed = 200
			
		print(throwSpeed)

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
	game_manager.playerx = self.position.x
	game_manager.playery = self.position.y


func _on_hitbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
