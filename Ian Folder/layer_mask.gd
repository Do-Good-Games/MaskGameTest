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
	img.blend_rect(brush, brush.get_used_rect(), brush_position - brush.get_used_rect().size /2.0)
	img_updated.emit(Rect2(
		brush_position - brush.get_used_rect().size/2.0,
		brush.get_used_rect().size
	))
	image_texture.update(img)

# Make this better
func erase_texture(brush_texture: Texture2D, brush_position: Vector2) -> void:
	var brush := brush_texture.get_image()
	var brush_rect := brush.get_used_rect()
	var draw_pos := brush_position - brush_rect.size / 2.0

	var img_size := img.get_size()

	for x in brush_rect.size.x:
		for y in brush_rect.size.y:
			var bx := x + brush_rect.position.x
			var by := y + brush_rect.position.y

			var dst_x := int(draw_pos.x + x)
			var dst_y := int(draw_pos.y + y)

			# Bounds check
			if dst_x < 0 or dst_y < 0 or dst_x >= img_size.x or dst_y >= img_size.y:
				continue

			var brush_alpha := brush.get_pixel(bx, by).a
			if brush_alpha <= 0.0:
				continue

			var dst_color := img.get_pixel(dst_x, dst_y)
			dst_color.a = max(dst_color.a - brush_alpha, 0.0)
			img.set_pixel(dst_x, dst_y, dst_color)
	image_texture.update(img)
	img_updated.emit(Rect2(
		brush_position - brush.get_used_rect().size/2.0,
		brush.get_used_rect().size
	))
