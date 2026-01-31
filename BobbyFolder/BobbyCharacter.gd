extends CharacterBody2D

#const Throwable: PackedScene = preload("res://BobbyFolder/throwable.tscn")
@export var Throwable: PackedScene

@export var speed = 200
@export var friction = 0.01
@export var acceleration = 0.1

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
	if Input.is_action_just_pressed("click"):
		print("we clicked")
		var createdThrowable = Throwable.instantiate()
		get_tree().root.add_child(createdThrowable)
		createdThrowable.global_transform = self.global_transform
	return input

func _physics_process(delta):
	look_at(get_global_mouse_position())
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
