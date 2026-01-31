extends CharacterBody2D

func _ready() -> void:
	#move to where the camera is
	move_toward(10, 20, 50)

func _physics_process(delta):
	move_and_slide()
