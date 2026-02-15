extends Node2D
@onready var area_2d = $Area2D

@export var path :String = "res://Levels/level2.tscn"

func _ready():
	if area_2d is Area2D:
		print("yay")
		area_2d.body_entered.connect(load_level)
	else :
		print("uhoh")
	

func load_level():
	print("hoi")
	get_tree().change_scene_to_file(path)


func _on_area_2d_body_entered(body):
	load_level()
	pass # Replace with function body.
