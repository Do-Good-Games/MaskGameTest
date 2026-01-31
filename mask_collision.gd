# Adapted from https://www.youtube.com/watch?v=Btk8IzhvaDo

class_name Layer extends Node2D

@export var epsilon := 10.0
@export var body: StaticBody2D
@export var rect_size := Vector2(100, 1000)

@onready var layer_mask: Sprite2D = $LayerMask
@onready var layer_area: Area2D = $LayerArea
@onready var unmasked_geometry: StaticBody2D = $UnmaskedGeometry
@onready var masked_geometry: StaticBody2D = $MaskedGeometry

var mask_bitmap: BitMap
var level_collision_polygons: Array[CollisionPolygon2D]
var regions: Dictionary[Rect2, Array] # {Region, Col. Polygons in region}

# NOTE: there's some weirdness with how it lines up, the outer edges are like 10 pixels too high
# but the inner edges are exactly right?


func _ready() -> void:
	var image := layer_mask.texture.get_image()
	
	mask_bitmap = BitMap.new()
	mask_bitmap.create_from_image_alpha(image)
	
	_register_collision_polygons(unmasked_geometry)
	_create_regions()
	generate_collision(mask_bitmap, regions.keys())


func generate_collision(bitmap: BitMap, region_rects: Array[Rect2]) -> void:
	for region_rect in region_rects:
		generate_collision_region(bitmap, region_rect)


func generate_collision_region(bitmap: BitMap, region_rect: Rect2) -> void:
	var polys := bitmap.opaque_to_polygons(
		region_rect, 
		epsilon
	)
	
	if regions.has(region_rect):
		print("clearing")
		_clear_collision_polys(regions[region_rect])
	
	for poly in polys:
		for level_collision_polygon in level_collision_polygons:
			var level_polygon := level_collision_polygon.polygon
			var adjusted_poly: PackedVector2Array = []
			for point in poly:
				var new_pos := point + region_rect.position
				if layer_mask.centered:
					new_pos -= bitmap.get_size() / 2.0
				adjusted_poly.append(new_pos)
			
			var bitmap_collision_polygon := CollisionPolygon2D.new()
			bitmap_collision_polygon.polygon = adjusted_poly
			layer_area.add_child(bitmap_collision_polygon)
			regions[region_rect].append(bitmap_collision_polygon)
			
			var adjusted_level_polygon: PackedVector2Array = []
			for point in level_polygon:
				var new_pos := level_collision_polygon.to_global(point)
				if layer_mask.centered:
					new_pos -= bitmap.get_size() / 2.0
				adjusted_level_polygon.append(new_pos)
			
			var intersected_polygons := Geometry2D.intersect_polygons(adjusted_poly, adjusted_level_polygon)
			
			if not intersected_polygons.is_empty():
				for intersected_polygon in intersected_polygons:
					if not Geometry2D.is_polygon_clockwise(intersected_polygon):
						var collision_polygon := CollisionPolygon2D.new()
						collision_polygon.polygon = intersected_polygon
						masked_geometry.add_child(collision_polygon)
						regions[region_rect].append(collision_polygon)


func _register_collision_polygons(static_body: StaticBody2D) -> Array[CollisionPolygon2D]:
	var polygons: Array[CollisionPolygon2D]
	for child in static_body.get_children():
		if child is CollisionPolygon2D:
			polygons.append(child)
	level_collision_polygons = polygons
	return polygons


func _clear_collision_polys(polys: Array) -> void:
	for poly: CollisionPolygon2D in polys:
		print("kill", poly)
		poly.queue_free()
	polys.clear()


func _create_regions() -> void:
	for x_index: int in ceil(layer_mask.texture.get_size().x / rect_size.x):
		for y_index: int in ceil(layer_mask.texture.get_size().y / rect_size.y):
			var x_start: float = x_index * rect_size.x
			var y_start: float = y_index * rect_size.y
			var start_pos := Vector2(x_start, y_start)
			
			var x_size: float = min(rect_size.x, layer_mask.texture.get_size().x - x_start)
			var y_size: float = min(rect_size.y, layer_mask.texture.get_size().y - y_start)
			var size := Vector2(x_size, y_size)
			regions.set(Rect2(start_pos, size), [])


func _on_layer_mask_img_updated(updated_region_rect: Rect2i, new_image: Image) -> void:
	var image_rect: Rect2i = Rect2i(Vector2.ZERO, new_image.get_size())
	
	var x_start: int = max(updated_region_rect.position.x, image_rect.position.x)
	var x_end: int = min(updated_region_rect.end.x, image_rect.end.x)
	
	var y_start: int = max(updated_region_rect.position.y, image_rect.position.y)
	var y_end: int = min(updated_region_rect.end.y, image_rect.end.y)
	
	for x in range(x_start, x_end):
		for y in range(y_start, y_end):
			mask_bitmap.set_bit(x, y, new_image.get_pixel(x, y).a > 0)
	
	for region_rect: Rect2 in regions.keys():
		if region_rect.intersection(updated_region_rect):
			generate_collision_region(mask_bitmap, region_rect)
