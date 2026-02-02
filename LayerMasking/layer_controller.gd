@tool
class_name Level extends Node2D

var layers: Array[Layer] = [null, null, null, null]

@onready var red_layer: Layer = $RedLayer
@onready var green_layer: Layer = $GreenLayer
@onready var blue_layer: Layer = $BlueLayer

var collision_types: Array[CollisionType] = [null, null]

@onready var collision: CollisionType = $Collision
@onready var hazard: CollisionType = $Hazard


#region Tooltip
# Ok everything you need is pretty much here, alpha values on all the 
# textures determine collision and shit. Main annoying thing is the size, 
# everything has to be the same size and you HAVE to change all the other 
# textures/viewports to match. Annoying but dont have time to automate rn 
# srry
@export var read_my_tooltip: bool = true:
	set(value):
		read_my_tooltip = value
		notify_property_list_changed()

@export var ok_fine_dont_read_it_then: bool = false:
	set(value):
		read_my_tooltip = value

func _validate_property(property: Dictionary) -> void:
	if property.name == "read_my_tooltip" and not read_my_tooltip:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name == "ok_fine_dont_read_it_then" and read_my_tooltip:
		property.usage = PROPERTY_USAGE_NO_EDITOR
#endregion

class color_texture_map:
	var map: Dictionary[String, Texture2D]
	func _init(type :String, img : Texture2D):
		map = {type: img}

#@export var textures_map : Dictionary [String, Dictionary[game_manager.color_enum, Texture2D]]


@export_category("Masks")
@export var red_mask: Texture2D
@export var green_mask: Texture2D
@export var blue_mask: Texture2D
#@export var mask_map: Dictionary [game_manager.lamp_color_enum, Texture2D]
@export_category("Collision")
@export var red_collision: Texture2D
@export var green_collision: Texture2D
@export var blue_collision: Texture2D
#@export var mask_map: Dictionary [game_manager.lamp_color_enum, Texture2D]
@export_category("Hazards")
@export var red_hazard: Texture2D
@export var green_hazard: Texture2D
@export var blue_hazard: Texture2D
@export_group("Debug")
@export var debug_paint: bool = true
@export var debug_brush: Texture2D
@export var debug_brush_scale := Vector2(0.5, 0.5)
var debug_selected_layer: game_manager.color_enum

@onready var composite_visuals: Sprite2D = $CompositeVisuals

var textures_map : Dictionary[game_manager.color_enum, color_texture_map] ={
	game_manager.color_enum.RED: color_texture_map.new("Masks", red_mask),
	#game_manager.color_enum.RED: color_texture_map.new("Collision", red_collision),
	#game_manager.color_enum.RED: color_texture_map.new("Hazards", red_hazard),
}


func _ready() -> void:
	#var brush_image := debug_brush.get_image()
	#brush_image.resize(brush_image.get_width() * debug_brush_scale.x, brush_image.get_height() * debug_brush_scale.y)
	#var brush_image_texture: ImageTexture = ImageTexture.new()
	#brush_image_texture.create_from_image(brush_image)
	#debug_brush = brush_image_texture
	layers[0] = null
	layers[1] = red_layer
	layers[2] = green_layer
	layers[3] = blue_layer
	layers[1].layer_mask.register_texture(red_mask)
	layers[2].layer_mask.register_texture(green_mask)
	layers[3].layer_mask.register_texture(blue_mask)
	
	collision_types[0] = collision
	collision_types[1] = hazard
	
	_set_shader_parameters(composite_visuals.material)
	for collision_type in collision_types:
		_set_shader_parameters(collision_type.mask.material)
	
	_set_collision_textures()

func _set_collision_textures() -> void:
	($Collision.mask.material as ShaderMaterial).set_shader_parameter(
		"red_texture", red_collision
	)
	($Collision.mask.material as ShaderMaterial).set_shader_parameter(
		"green_texture", green_collision
	)
	($Collision.mask.material as ShaderMaterial).set_shader_parameter(
		"blue_texture", blue_collision
	)
	
	($Hazard.mask.material as ShaderMaterial).set_shader_parameter(
		"red_texture", red_hazard
	)
	($Hazard.mask.material as ShaderMaterial).set_shader_parameter(
		"green_texture", green_hazard
	)
	($Hazard.mask.material as ShaderMaterial).set_shader_parameter(
		"blue_texture", blue_hazard
	)

func _set_shader_parameters(shader: ShaderMaterial) -> void:
	shader.set_shader_parameter("red_mask", layers[1].layer_mask.texture)
	shader.set_shader_parameter("green_mask", layers[2].layer_mask.texture)
	shader.set_shader_parameter("blue_mask", layers[3].layer_mask.texture)
	shader.set_shader_parameter("red_temp_masks", $RedLayer/TempMasks.get_texture())
	shader.set_shader_parameter("green_temp_masks", $GreenLayer/TempMasks.get_texture())
	shader.set_shader_parameter("blue_temp_masks", $BlueLayer/TempMasks.get_texture())


func paint_texture(layer_name: game_manager.color_enum, brush_position: Vector2, brush_texture: Texture2D, brush_scale := Vector2(0.5,0.5)) -> void:
	var updated_rect: Rect2
	for i in layers.size():
		if i == 0:
			continue
		if i == layer_name:
			updated_rect = layers[i].layer_mask.paint_texture(brush_texture, brush_position, brush_scale)
		else:
			layers[i].layer_mask.erase_texture(brush_texture, brush_position, brush_scale)
	
	#for collision_type in collision_types:
		#collision_type.handle_rect_update(updated_rect)


func add_temp_mask(layer_name: game_manager.color_enum, mask: Node2D , scale: float = 1) -> Node2D:
	var layer: Layer = layers[layer_name]
	
	if mask.get_parent() != null:
		mask.get_parent().remove_child(mask)
	layer.temp_masks.add_child(mask)
	return mask


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and debug_paint:
		if event.pressed:
			print(get_global_mouse_position())
			paint_texture(debug_selected_layer, get_global_mouse_position(), debug_brush)
	if event is InputEventMouseMotion and debug_paint and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		paint_texture(debug_selected_layer, get_local_mouse_position(), debug_brush)
	if event is InputEventKey and debug_paint:
		if event.keycode == KEY_1:
			debug_selected_layer = game_manager.color_enum.RED
		if event.keycode == KEY_2:
			debug_selected_layer = game_manager.color_enum.GREEN
		if event.keycode == KEY_3:
			debug_selected_layer = game_manager.color_enum.BLUE


func _on_collision_redraw_timer_timeout() -> void:
	pass
	#for collision_type in collision_types:
		#if not collision_type.dirty_regions.is_empty():
			#pass
			#collision_type.collision_thread.start(collision_type.update_dirty_regions)
