extends RayCast2D

@export var epsilon: int = 5
@export var shape: Shape2D
@export var frequency: float = 0.2

@onready var timer: Timer = $Timer

var shapes_by_type: Dictionary[CollisionType, CollisionShape2D]
var direction: Vector2
var length: int

func _ready() -> void:
	if RoomManager.current_level == null:
		await RoomManager.level_ready
	if RoomManager.busy:
		await RoomManager.level_ready
	for collision_type: CollisionType in RoomManager.current_level.collision_types:
		shapes_by_type.set(collision_type, collision_type.give_shape(shape))
	timer.wait_time = frequency
	
	direction = target_position.normalized()
	length = target_position.length() as int


func _on_timer_timeout() -> void:
	if RoomManager.busy:
		return
	for collision_type: CollisionType in shapes_by_type.keys():
		collision_type.do_color_cast(
			global_position, 
			direction.rotated(rotation),
			length,
			shapes_by_type[collision_type],
			epsilon
		)
