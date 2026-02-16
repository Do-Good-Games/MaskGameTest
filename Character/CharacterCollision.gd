extends Area3D


func _on_area_entered(area: Area3D) -> void:
	if(area.is_in_group("Enemy")):
		print("GET HURT")
