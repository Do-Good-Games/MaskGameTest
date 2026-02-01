class_name Throwable extends CharacterBody2D
@onready var throwable: CharacterBody2D = $"."

@export var speed = 60
var throwtime = 120

func _ready() -> void:
	move_toward(10, 20, 50)

func _physics_process(delta):
	
	if(throwtime >= 0):
		print("throwitme " , throwtime, " speed ", speed)
		throwtime = throwtime - 1
		velocity = transform.x * speed
	else:
		print("throwitme " , throwtime, " speed ", speed)
		velocity = transform.x * 0
	
	move_and_slide()
	
func deactivate():
	#self.disabled = true
	pass

func reactivate():
	throwtime = 120
	pass
