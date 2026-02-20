extends Camera3D

@export var color: GameManager.color_enum = GameManager.color_enum.NONE

func _ready():
	CameraController.set_camera(color, self)
