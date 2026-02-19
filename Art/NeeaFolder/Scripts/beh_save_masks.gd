extends Node

# To Do:
# loop all 3 color scenes and render out each mask
# currently, only the bottom scene will be rendered, the other two need to be hidden

enum {LEVEL, COLOR, DIMENSION} # scene node name
const LAYERS_MASK : Dictionary = {"col": 2, "haz": 3}
const LAYERS_ALL : int = 1048575
const WINDOW_SIZE = Vector2i(1920, 1080)

@export var disable_render : bool
@export var name_prefix : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if disable_render: return
	
	# example names:
	# lvl1_blue_col_3D.png
	# lvl1_blue_haz_3D.png
	# lvl1_blue_mask_3D.png
	
	var viewport : Viewport = get_viewport()
	#print(viewport.name)
	
	# get all level scenes based on name pattern and type
	var scenes : Array[Node] = viewport.find_children("lvl*_*_?D", "Node3D", false)
	
	# get original scene visibility
	var scene_visible : Array[bool]
	for i : int in range(len(scenes)):
		scene_visible.append(scenes[i].is_visible())
		#print(scenes[i].name, scene_visible[-1])
	
	# hide all scenes
	for scene : Node3D in scenes:
		scene.set_visible(false)
	
	# reveal, save masks, hide
	for i : int in range(len(scenes)):
		if not scene_visible[i]: continue
		
		scenes[i].set_visible(true)
		save_masks(viewport, scenes[i])
		#scenes[i].set_visible(false)
		break

func save_masks(viewport : Viewport, render_scene : Node3D) -> void:
	#var render_scene : Node3D = viewport.get_children()[-1]
	var scene_name : String = render_scene.name
	
	# build file path base
	var delim : String = "_"
	var name_parts : PackedStringArray = scene_name.split(delim)
	
	# exit if name does not have 3 parts
	if len(name_parts) != 3:
		print("scene root node name is incorrect:\nFormat: lvl<number>_<color>_3D\nCurrent Name:" + scene_name)
		return
	
	var file_name_prefix : String
	if len(name_prefix) > 0: file_name_prefix = name_prefix + delim
	
	var folder_name : String = "Level" + name_parts[LEVEL][-1] + name_parts[DIMENSION]
	var file_name_base : String = file_name_prefix + name_parts[LEVEL] + delim + name_parts[COLOR] + delim
	var file_path_base : String = "res://Levels/" + folder_name + "/"
	
	# get camera
	var cam : Camera3D = viewport.get_camera_3d()
	
	# save masks
	for layer : String in LAYERS_MASK.keys():
		# change camera mask
		cam.cull_mask = 0;
		cam.set_cull_mask_value(LAYERS_MASK[layer], true)
		
		# complete file name
		var file_name : String = file_name_base + layer + delim + name_parts[DIMENSION] + ".png"
		var file_path : String = file_path_base + file_name
		#print(file_path)
		
		# get rendered image
		await RenderingServer.frame_post_draw
		var img : Image = viewport.get_texture().get_image()
		
		# save image
		img.save_png(file_path)
		
		if FileAccess.file_exists(file_path):
			print("saved image to: " + file_path)
		else:
			print("file could not save to: " + file_path)
