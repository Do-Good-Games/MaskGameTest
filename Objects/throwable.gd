class_name Throwable extends CharacterBody2D
@onready var throwable: CharacterBody2D = $"."

@export var speed = 60

#@export var max_speed
var throwtime = 120

var target_pos : Vector2

var throwing : bool = false

func _ready() -> void:
	move_toward(10, 20, 50)

func _physics_process(delta):
	
	
	if(throwing):
		var object_to_repos : CharacterBody2D
		object_to_repos =  get_parent() as CharacterBody2D
		var lerp = lerp(0 , speed, throwtime/120.0)
		#print("throwing", throwtime, " lerp ", lerp, " s" , speed)
		object_to_repos.position = object_to_repos.position.move_toward(target_pos, lerp)
		throwtime -=1
		if throwtime < 0:
			throwing  = false
		
		
		
		#object_to_repos.position += object_to_repos.position.move_toward(mouse)
		#direction_to(Vector2(game_manager.playerx,game_manager.playery)) * 100 * delta
		
	
	#if(throwtime >= 0):
		#
		#print("throwitme " , throwtime, " speed ", speed)
		#throwtime = throwtime - 1
		#var parent : Node = get_parent() 
		#if parent is RigidBody2D:
			#parent.velocity = transform.x * speed
	#else:
		#throwing = false
		#var parent : Node = get_parent() 
		#if parent is RigidBody2D:
			#parent.velocity = transform.x * 0
	#
	#move_and_slide()
	#if throwing:
		#print()
		#var parent : Node2D = get_parent() as Node2D
		#
		#parent.global_position = global_position
	
func deactivate():
	#self.disabled = true
	pass

func reactivate():
	throwtime = 120
	pass
