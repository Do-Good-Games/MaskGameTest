extends Control

var ispaused : bool = true
@onready var pause_menu : CanvasLayer = $CanvasLayer
@onready var resume_button : Button = $"CanvasLayer/Button Container/Resume Button"
@onready var MM_button : Button = $"CanvasLayer/Button Container/MM Button"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resume_button.pressed.connect(_resume)
	MM_button.pressed.connect(_exit_to_MM)

	print("FIONA TEST")
	
	get_tree().paused = false
	pause_menu.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if(ispaused):
			print("Game Paused")
			pause_menu.show()
			get_tree().paused = true
			ispaused = false
		else:
			pause_menu.hide()
			get_tree().paused = false
			ispaused = true
			
		
func _resume() -> void:
	print("Game Unpaused")
	get_tree().paused = false
	ispaused = true
	pause_menu.hide()
			
func _exit_to_MM() -> void:
	print("Exiting to MM")
	print("Unpausing Game")
	pause_menu.hide()
	get_tree().paused = false
	ispaused = true
	
	get_tree().change_scene_to_file("res://Menus/mainMenu.tscn")
