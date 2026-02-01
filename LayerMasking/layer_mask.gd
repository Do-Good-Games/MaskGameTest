class_name LayerMask extends Sprite2D


signal img_updated(updated_region: Rect2i, new_image: Image)

var img: Image
var image_texture: ImageTexture
var image_rect: Rect2i

func register_texture(new_texture: Texture2D) -> void:
	img = new_texture.get_image()
	image_texture = ImageTexture.create_from_image(img)
	image_rect = Rect2i(Vector2.ZERO, img.get_size())
	texture = image_texture


#func _update_texture() -> void:
	#texture.upd


func paint_texture(brush_texture: Texture2D, brush_position: Vector2, brush_scale := Vector2(1, 1)) -> Rect2i:
	var brush := brush_texture.get_image()
	if brush_scale != Vector2(1,1):
		brush.resize(brush.get_width() * brush_scale.x, brush.get_height() * brush_scale.y)
	
	var brush_rect := Rect2i(Vector2.ZERO, brush.get_size())
	
	img.blend_rect(brush, brush_rect, brush_position - brush_rect.size /2.0)
	image_texture.update(img)
	var updated_rect := Rect2i(
		brush_position - brush_rect.size/2.0,
		brush_rect.size
	)
	img_updated.emit(updated_rect, img)
	return updated_rect


func paint_circle(radius: float, circle_pos: Vector2) -> void:
	var circle_rect := Rect2(Vector2(circle_pos.x-radius, circle_pos.y-radius), Vector2(radius*2, radius*2))
	# Dont paint outside of the image
	var x_start: int = max(circle_rect.position.x, image_rect.position.x)
	var x_end: int = min(circle_rect.end.x, image_rect.end.x)
	
	var y_start: int = max(circle_rect.position.y, image_rect.position.y)
	var y_end: int = min(circle_rect.end.y, image_rect.end.y)
	
	# Iterate through the rectangle the circle occupies
	for x in range(x_start, x_end):
		for y in range(y_start, y_end):
			var pos := Vector2i(x, y)
			# Paint if this position is within the circle
			if pos.distance_squared_to(circle_pos) <= radius*radius:
				img.set_pixelv(pos, Color.WHITE)


# Make this better
func erase_texture(brush_texture: Texture2D, brush_position: Vector2, brush_scale := Vector2(1, 1)) -> Rect2i:
	var brush := brush_texture.get_image()
	brush.resize(brush.get_width() * brush_scale.x, brush.get_height() * brush_scale.y)
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
	var updated_rect := Rect2i(
		brush_position - brush.get_used_rect().size/2.0,
		brush.get_used_rect().size
	)
	img_updated.emit(updated_rect, img)
	return updated_rect
