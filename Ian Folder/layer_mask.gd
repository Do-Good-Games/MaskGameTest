extends Sprite2D


var img: Image

func _ready() -> void:
	img = texture.get_image()


#func _update_texture() -> void:
	#texture.upd


func paint_texture(brush_texture: Texture2D, brush_position: Vector2) -> void:
	var brush := brush_texture.get_image()
	img.blend_rect(brush, brush.get_used_rect(), brush_position - brush.get_used_rect().size/2.0)
	
