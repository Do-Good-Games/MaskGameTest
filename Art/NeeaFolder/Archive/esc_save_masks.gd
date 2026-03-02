@tool
extends EditorScript

enum {LEVEL, COLOR, DIMENSION}
const layers : Dictionary = {"col": 2, "haz": 3}
const ALL_LAYERS : int = 1048575

# Called when the script is executed (using File -> Run in Script Editor).
# run: ctrl + shift + x
func _run() -> void:
	# name of scene for level number
	# type of mask from layer
	
	# lvl1_blue_col_3D.png
	# lvl1_blue_haz_3D.png
	# lvl1_blue_mask_3D.png
	
	# assume 3D levels
	
	# loop dictionary enumerate keys and values
	# set camera layer to vlaue
	# get mask type from key
	# build file path
	# wait to for frame post draw?
	# save render
	# return to normal layer
	
	# await RenderingServer.frame_post_draw
	# scene.get_viewport().get_texture().get_image().save_png(file_path)
	
	# get current scene tab
	var scene : Node = EditorInterface.get_edited_scene_root()
	# exit if not a 3D node
	if !scene.is_class("Node3D"):
		print("current edited scene is not a 3D level")
		return
	
	# build file path base
	var delim : String = "_"
	var name_parts = scene.name.split(delim)
	# exit if name incorrect
	if len(name_parts) != 3:
		print("scene root node name is incorrect:\nFormat: lvl<number>_<color>_3D\nCurrent Name:" + scene.name)
		return
	
	var folder_name : String = "Level" + name_parts[LEVEL][-1] + name_parts[DIMENSION]
	var file_name_base : String = name_parts[LEVEL] + delim + name_parts[COLOR] + delim
	var file_path_base : String = "res://Levels/" + folder_name + "/"
	
	# loop dictionary enumerate keys and values
	#for layer in layers.keys():
		#var file_name : String = file_name_base + layer + delim + name_parts[DIMENSION] + "." + ext
		#var file_path : String = file_path_base + file_name
		#print(file_path)
	
	# could change mask camera to current then change back
	# need to change player camera not current then back
	
	# get camera
	var cam : Camera3D = scene.get_node("Camera3DMask")
	
	# test change layers
	var layer : String = "col"
	cam.cull_mask = 0;
	cam.set_cull_mask_value(layers[layer], true)
	
	# reset layers
	#cam.cull_mask = ALL_LAYERS
	#for layer in layers.keys():
		#cam.set_cull_mask_value(layers[layer], false)
	
	# test save render
	var file_name : String = file_name_base + layer + delim + name_parts[DIMENSION] + ".png"
	var file_path : String = file_path_base + file_name
	#file_path = "res://" + file_name
	
	# this renders the scene viewport not the cameras
	# if the camera is previewed it will render in whatever resolution its at
	#var viewport = EditorInterface.get_editor_viewport_3d(0)
	var viewport = scene.get_viewport()
	var img = viewport.get_texture().get_image()
	
	#await RenderingServer.frame_post_draw
	img.save_png(file_path)
	if FileAccess.file_exists(file_path):
		print("saved image to: " + file_path)
	else:
		print("file could not save to: " + file_path)
