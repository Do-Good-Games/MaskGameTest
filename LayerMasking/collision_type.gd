class_name CollisionType extends StaticBody2D

@export var epsilon := 10.0
@export var rect_size := Vector2(1000, 1000)
@export var centered_visuals: bool = false

@onready var sub_viewport: SubViewport = $SubViewport

var mask_bitmap: BitMap
var regions: Dictionary[Rect2, Array] # {Region, Col. Polygons in region}
var dirty_regions: Array[Rect2]


func generate_collision_region(bitmap: BitMap, region_rect: Rect2) -> void:
	var polys := bitmap.opaque_to_polygons(region_rect, epsilon);
	
	print(polys)
	
	if regions.has(region_rect):
		_clear_collision_polys(regions[region_rect])
	
	for poly in polys:
		var adjusted_poly: PackedVector2Array = []
		for point in poly:
			var new_pos := point + region_rect.position
			if centered_visuals:
				new_pos -= bitmap.get_size() / 2.0
			adjusted_poly.append(new_pos)
		
		var collision_polygon := CollisionPolygon2D.new()
		collision_polygon.polygon = adjusted_poly
		add_child(collision_polygon)
		regions[region_rect].append(collision_polygon)


func _clear_collision_polys(polys: Array) -> void:
	for poly: CollisionPolygon2D in polys:
		poly.queue_free()
	polys.clear()


func _create_regions() -> void:
	for x_index: int in ceil(sub_viewport.get_texture().get_size().x / rect_size.x):
		for y_index: int in ceil(sub_viewport.get_texture().get_size().y / rect_size.y):
			var x_start: float = x_index * rect_size.x
			var y_start: float = y_index * rect_size.y
			var start_pos := Vector2(x_start, y_start)
			
			var x_size: float = min(rect_size.x, sub_viewport.get_texture().get_size().x - x_start)
			var y_size: float = min(rect_size.y, sub_viewport.get_texture().get_size().y - y_start)
			var size := Vector2(x_size, y_size)
			regions.set(Rect2(start_pos, size), [])
			dirty_regions.append(Rect2(start_pos, size))


func update_dirty_regions() -> void:
	await RenderingServer.frame_post_draw 
	var viewport_image := sub_viewport.get_texture().get_image()
	var image_rect: Rect2i = Rect2i(Vector2.ZERO, viewport_image.get_size())
	
	if mask_bitmap == null:
		mask_bitmap = BitMap.new()
		mask_bitmap.create_from_image_alpha(viewport_image)
	
	for region: Rect2 in dirty_regions:
		var x_start: int = max(region.position.x, image_rect.position.x)
		var x_end: int = min(region.end.x, image_rect.end.x)
	
		var y_start: int = max(region.position.y, image_rect.position.y)
		var y_end: int = min(region.end.y, image_rect.end.y)
		for x in range(x_start, x_end):
			for y in range(y_start, y_end):
				mask_bitmap.set_bit(x, y, viewport_image.get_pixel(x,y).a > 0)
				if viewport_image.get_pixel(x,y).a > 0:
					print("AAAAH")
		generate_collision_region(mask_bitmap, region)
	dirty_regions.clear()
	
	#for region_rect: Rect2 in regions.keys():
		#if region_rect.intersection(updated_region_rect):
			#generate_collision_region(mask_bitmap, region_rect)


func handle_rect_update(updated_region_rect: Rect2i) -> void:
	for region_rect: Rect2 in regions.keys():
		if region_rect.intersection(updated_region_rect):
			dirty_regions.append(region_rect)
