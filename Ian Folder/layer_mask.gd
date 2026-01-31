class_name LayerMask extends Sprite2D


signal img_updated(updated_region: Rect2)

var img: Image
var image_texture: ImageTexture

func _ready() -> void:
	img = texture.get_image()
	image_texture = ImageTexture.create_from_image(img) 
	texture = image_texture


#func _update_texture() -> void:
	#texture.upd


func paint_texture(brush_texture: Texture2D, brush_position: Vector2) -> void:
	var brush := brush_texture.get_image()
	img.blend_rect(brush, brush.get_used_rect(), brush_position - brush.get_used_rect().size * 1.0)
	img_updated.emit(Rect2(
		brush_position - brush.get_used_rect().size/2.0,
		brush.get_used_rect().size
	))
	image_texture.update(img)
	
