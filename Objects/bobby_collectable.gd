class_name BobbyCollectible extends Area2D


@export var has_parent: bool = false

var inGravity = false
var inGrab = false

var goingToPlayer = false

signal collected

func _process(delta: float) -> void:
	if Input.is_action_pressed("left_click"):
		if(inGravity):
			activate_gravity(delta)
		if(inGrab):
			activate_grab()
			#self.queue_free()
			
	if Input.is_action_just_released("left_click"):
		goingToPlayer = false

func deactivate():
	print("object deactivated?")

func _physics_process(delta: float) -> void:
	if(goingToPlayer):
		var object_to_repos
		if has_parent:
			object_to_repos =  get_parent()
		else :
			object_to_repos = self
		object_to_repos.position += object_to_repos.position.direction_to(Vector2(game_manager.playerx,game_manager.playery)) * 100 * delta
		

func activate_grab() -> void:
	collected.emit()
	deactivate()

func activate_gravity(delta: float) -> void:
	goingToPlayer = true

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		print("we hit the player group")
		#self.queue_free()

func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Gravity")):
		inGravity = true
		
	if(area.is_in_group("Grab")):
		inGrab = true

func _on_area_exited(area: Area2D) -> void:
	if(area.is_in_group("Gravity")):
		inGravity = false
		
	if(area.is_in_group("Grab")):
		inGrab = false
