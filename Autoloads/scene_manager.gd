class_name SceneManager extends Node

signal transition_started(unloading_scene: Node)
signal scene_freed(scene: Node)
signal scene_ready(scene: Node)
signal transition_finished(loaded_scene: Node)

@export var parent_node: Node
@export_file("*.tscn") var default_scene: String
@export var default_animator: AnimationPlayer = null
@export var to_black_anim_name: String = "to_black"
@export var from_black_anim_name: String = "from_black"



var current_scene: Node
#var scene_file_name: String:
	#get:
		#var scene_path: String = ResourceUID.get_id_path(ResourceUID.text_to_id(RoomManager.current_scene_uid))
		## Ok so I gotta admit this is a bit hacky
		## Sometimes current_scene_uid is just a path and not a UID and you gotta deal with it
		#return scene_path.get_file()
#var scene_file_basename: String:
	#get:
		#return scene_file_name.get_basename()
# This is a filepath sometimes idk man just deal with it
#var current_scene_uid: String
var busy: bool = false


func _ready() -> void:
	# Parent node defaults to root
	if parent_node == null:
		parent_node = get_tree().root
	
	if parent_node.get_children().size() > 0:
		current_scene = parent_node.get_child(parent_node.get_children().size() - 1)
		#current_scene_uid = (current_scene.scene_file_path)
		
	else:
		#current_scene_uid = default_scene
		current_scene = load(default_scene).instantiate()
		parent_node.add_child(current_scene)

func load_scene(new_scene_uid: String, anim: AnimationPlayer = default_animator) -> void:
	if busy:
		return
	busy = true
	#current_scene_uid = new_scene_uid
	var next_scene: Node = load(new_scene_uid).instantiate()
	next_scene.z_index = -1
	
	transition_started.emit(current_scene)
	await _play_transition(to_black_anim_name, anim)
	#Could happen earlier maybe, but it sorta lags
	parent_node.add_child(next_scene)
	
	current_scene.queue_free()
	scene_freed.emit(current_scene)
	
	next_scene.z_index = 0
	current_scene = next_scene
	scene_ready.emit(current_scene)
	
	await _play_transition(from_black_anim_name, anim)
	busy = false
	transition_finished.emit(current_scene)


func change_parent(new_parent: Node) -> void:
	if not is_node_ready():
		await ready
	if new_parent != null:
		parent_node.remove_child.call_deferred(current_scene)
		#parent_node.remove_child(current_scene)
		parent_node = new_parent
		parent_node.add_child.call_deferred(current_scene)


func _play_transition(anim_name: String, anim: AnimationPlayer) -> void:
	if anim != null and anim.has_animation(anim_name):
		anim.play(anim_name)
		await anim.animation_finished
