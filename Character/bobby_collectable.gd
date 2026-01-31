extends Area2D

var inGravity = false
var inGrab = false



func get_input():
	if Input.is_action_pressed("click"):
		if(inGravity):
			print("activate gravity")
		if(inGrab):
			print("active grab")
			
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		print("clicked")
		if(inGravity):
			print("activate gravity")
		if(inGrab):
			print("active grab")

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if(body.is_in_group("Player")):
		print("we hit the player group")
		#self.queue_free()

func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Gravity")):
		print("we are in gravity")
		inGravity = true
		
	if(area.is_in_group("Grab")):
		print("we are in grab")
		inGrab = true


func _on_area_exited(area: Area2D) -> void:
	if(area.is_in_group("Gravity")):
		print("we are leaving gravity")
		inGravity = false
		
	if(area.is_in_group("Grab")):
		print("we are leaving grab")
		inGrab = false
