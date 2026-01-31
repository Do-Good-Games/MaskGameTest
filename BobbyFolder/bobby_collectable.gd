extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print(body)
	if(body.is_in_group("Player")):
		print("we hit the player group")
		self.queue_free()
