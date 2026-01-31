extends CharacterBody2D

@export var speed = 60
var throwtime = 120

func _ready() -> void:
	print("i live")
	move_toward(10, 20, 50)

func _physics_process(delta):
	
	if(throwtime >= 0):
		throwtime = throwtime - 1
		velocity = transform.x * speed
	else:
		velocity = transform.x * 0
	
	move_and_slide()
