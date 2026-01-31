class_name Room extends Node2D

signal transition_triggered(next_room: Room, spawn_point: String)
signal spawn_point_changed(new_spawn: SpawnPoint)

@export var default_spawn: SpawnPoint
var active_spawn_point: SpawnPoint: 
	get:
		return default_spawn if active_spawn_point == null else active_spawn_point

var spawn_points: Array[SpawnPoint]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	active_spawn_point = default_spawn


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart"):
		#RoomManager.load_room(active_spawn_point)
		RoomManager.reset_current_room()

func set_spawn_point_by_id(id: String) -> bool:
	for node: SpawnPoint in get_tree().get_nodes_in_group("spawn_points"):
		if node is SpawnPoint:
			var spawn_point: SpawnPoint = node as SpawnPoint
			if spawn_point.id == id:
				active_spawn_point = spawn_point
				return true
	
	return false


func set_spawn_point(spawn: SpawnPoint) -> void:
	#print_debug("New spawnpoint: ", spawn.id)
	active_spawn_point = spawn
	push_error("test")
	spawn_point_changed.emit(spawn)


func spawn_player(do_entrance_animation: bool = false) -> void:
	if active_spawn_point == null:
		active_spawn_point = default_spawn
	
	if active_spawn_point:
		var child: Node = active_spawn_point.spawn()
		add_child(child)
		child.global_position = active_spawn_point.global_position


## Adopts an AudioStreamPlayer and plays its stream
## Obviously, more expensive than handling locally
func play_stream_globally(stream_player: AudioStreamPlayer) -> void:
	if stream_player == null:
		return
	_adopt_node(stream_player)
	stream_player.play()
	stream_player.finished.connect(stream_player.queue_free)


## Adopts an AudioStreamPlayer2D and plays its stream, preserving global position
## Obviously, more expensive than handling locally
func play_positional_stream_globally(stream_player: AudioStreamPlayer2D) -> void:
	if stream_player == null:
		return
	_adopt_node_preserve_position(stream_player)
	stream_player.play()
	stream_player.finished.connect(stream_player.queue_free)

## Adopts a particle emitter and handles it globally
func emit_CPU_particles_globally(emitter: CPUParticles2D) -> void:
	if emitter == null:
		return
	_adopt_node_preserve_position(emitter)
	emitter.emitting = true
	emitter.finished.connect(emitter.queue_free)


## Adopts a particle emitter and handles it globally
func emit_GPU_particles_globally(emitter: GPUParticles2D) -> void:
	if emitter == null:
		return
	_adopt_node_preserve_position(emitter)
	emitter.emitting = true
	emitter.finished.connect(emitter.queue_free)


func _adopt_node(node: Node) -> void:
	if node == null or node.get_parent() == null:
		return
	node.get_parent().remove_child(node)
	add_child(node)
	node.owner = self


func _adopt_node_preserve_position(node: Node2D) -> void:
	if node == null:
		return
	var old_position := node.global_position
	_adopt_node(node)
	node.global_position = old_position


func _on_transition_triggered(next_room: PackedScene, spawn_point: String = "") -> void:
	transition_triggered.emit(next_room, spawn_point)
