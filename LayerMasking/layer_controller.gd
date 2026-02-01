class_name Level extends Node2D

enum LayerName{
	RED = 0,
	GREEN = 1,
	BLUE = 2,
}

@export var layers: Array[Layer]

func paint_texture(layer_name: LayerName, brush_texture: Texture2D, brush_position: Vector2, brush_scale := Vector2i(1,1)) -> void:
	for i in layers.size():
		if i == layer_name:
			layers[i].layer_mask.paint_texture(brush_texture, brush_position, brush_scale)
		else:
			layers[i].layer_mask.erase_texture(brush_texture, brush_position, brush_scale)
