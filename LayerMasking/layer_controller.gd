class_name Level extends Node2D

enum LayerName{
	RED = 0,
	GREEN = 1,
	BLUE = 2,
}

@export var layers: Array[Layer]
@export var collision_types: Array[CollisionType]
@export var debug_paint: bool = true
@export var debug_brush: Texture2D
var debug_selected_layer: LayerName

@onready var composite_visuals: Sprite2D = $CompositeVisuals


func _ready() -> void:
	printerr("uwu")
	
	_set_shader_parameters(composite_visuals.material)
	for collision_type in collision_types:
		_set_shader_parameters(collision_type.mask.material)
		#collision_type._create_regions()
		#_set_shader_parameters($CollisionMask2.material)


func _set_shader_parameters(shader: ShaderMaterial) -> void:
	shader.set_shader_parameter("red_mask", layers[0].layer_mask.image_texture)
	shader.set_shader_parameter("green_mask", layers[1].layer_mask.image_texture)
	shader.set_shader_parameter("blue_mask", layers[2].layer_mask.image_texture)


func paint_texture(layer_name: LayerName, brush_texture: Texture2D, brush_position: Vector2, brush_scale := Vector2i(1,1)) -> void:
	var updated_rect: Rect2
	for i in layers.size():
		if i == layer_name:
			updated_rect = layers[i].layer_mask.paint_texture(brush_texture, brush_position, brush_scale)
		else:
			layers[i].layer_mask.erase_texture(brush_texture, brush_position, brush_scale)
	
	#for collision_type in collision_types:
		#collision_type.handle_rect_update(updated_rect)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and debug_paint:
		if event.pressed:
			paint_texture(debug_selected_layer, debug_brush, get_local_mouse_position())
	if event is InputEventKey and debug_paint:
		if event.keycode == KEY_1:
			debug_selected_layer = LayerName.RED
		if event.keycode == KEY_2:
			debug_selected_layer = LayerName.GREEN
		if event.keycode == KEY_3:
			debug_selected_layer = LayerName.BLUE


func _on_collision_redraw_timer_timeout() -> void:
	pass
	#for collision_type in collision_types:
		#if not collision_type.dirty_regions.is_empty():
			#pass
			#collision_type.collision_thread.start(collision_type.update_dirty_regions)
