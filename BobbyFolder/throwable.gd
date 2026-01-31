extends CharacterBody2D

func _ready() -> void:
	print("i live")
	move_toward(10, 20, 50)

func _physics_process(delta):
	#velocity = velocity.lerp(Vector2.from_angle(0) * 20, 1)
	velocity = transform.x * 15
	move_and_slide()
