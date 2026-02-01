extends Area2D
var chasingPlayer = false


func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Player")):
		chasingPlayer = true
		
func _on_area_exited(area: Area2D) -> void:
	if(area.is_in_group("Player")):
		chasingPlayer = false

func _physics_process(delta: float) -> void:
	if(chasingPlayer):
		position += position.direction_to(Vector2(game_manager.playerx,game_manager.playery)) * 100 * delta
