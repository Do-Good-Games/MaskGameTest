@tool
extends EditorScript

# Called when the script is executed (using File -> Run in Script Editor).
# run: ctrl + shift + x
func _run() -> void:
	# name of scene for level number
	# type of mask from layer
	
	# lvl1_blue_col.png
	# lvl1_blue_haz.png
	# lvl1_blue_mask.png
	
	# assume 3D levels
	
	# loop dictionary enumerate keys and values
	# set camera layer to vlaue
	# get mask type from key
	# build file path
	# wait to for frame post draw?
	# save render
	
	# await RenderingServer.frame_post_draw
	# scene.get_viewport().get_texture().get_image().save_png(file_path)
	
	var scene : Node = EditorInterface.get_edited_scene_root()
	var layers : Dictionary = {"col": 2, "haz": 3}
	
	var ext : String = "png"
	var delim : String = "_"
	var scene_name_parts = scene.name.split(delim)
	var folder_name : String = scene_name_parts[0]
	var color : String = scene_name_parts[1]
	var level_num : String = folder_name[folder_name.find("3D") - 1]
	
	var mask_type = layers.keys()[0]
	var file_name : String = "lvl" + level_num + delim + color + delim + mask_type + delim + "3D"
	var file_path : String = "res://Levels/" + folder_name + "/" + file_name + "." + ext
	
	print(file_path)
	
	#scene.get_viewport().get_texture().get_image().save_png(file_path)
