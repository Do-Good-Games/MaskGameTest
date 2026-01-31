# Adapted from https://www.youtube.com/watch?v=Btk8IzhvaDo

extends StaticBody2D

@export var epsilon := 10.0
@export var body: StaticBody2D
@export var rect_size := Vector2(100, 1000)

@onready var layer_mask: Sprite2D = $LayerMask
@onready var layer_area: Area2D = $LayerArea
@onready var unmasked_geometry: StaticBody2D = $UnmaskedGeometry

var level_collision_polygons: Array[CollisionPolygon2D]

# NOTE: there's some weirdness with how it lines up, the outer edges are like 10 pixels too high
# but the inner edges are exactly right?


func _ready() -> void:
	var image := layer_mask.texture.get_image()
	
	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(image)
	
	_register_collision_polygons(unmasked_geometry)
	
	generate_collision(bitmap)

func generate_collision(bitmap: BitMap) -> void:
	for x_index: int in ceil(layer_mask.texture.get_size().x / rect_size.x):
		for y_index: int in ceil(layer_mask.texture.get_size().y / rect_size.y):
			var x_start: float = x_index * rect_size.x
			var y_start: float = y_index * rect_size.y
			var start_pos := Vector2(x_start, y_start)
			
			var x_size: float = min(rect_size.x, layer_mask.texture.get_size().x - x_start)
			var y_size: float = min(rect_size.y, layer_mask.texture.get_size().y - y_start)
			var size := Vector2(x_size, y_size)
			generate_collision_region(bitmap, start_pos, size)


func generate_collision_region(bitmap: BitMap, start_pos: Vector2, size: Vector2) -> void:
	var polys := bitmap.opaque_to_polygons(
		Rect2(start_pos, size), 
		epsilon
	)
	
	for poly in polys:
		for level_collision_polygon in level_collision_polygons:
			var level_polygon := level_collision_polygon.polygon
			var adjusted_poly: PackedVector2Array = []
			for point in poly:
				var new_pos := point + start_pos
				if layer_mask.centered:
					new_pos -= bitmap.get_size() / 2.0
				adjusted_poly.append(new_pos)
			
			var bitmap_collision_polygon := CollisionPolygon2D.new()
			bitmap_collision_polygon.polygon = adjusted_poly
			layer_area.add_child(bitmap_collision_polygon)
			
			var adjusted_level_polygon: PackedVector2Array = []
			for point in level_polygon:
				adjusted_level_polygon.append(level_collision_polygon.to_global(point))
			
			var intersected_polygons := Geometry2D.intersect_polygons(adjusted_poly, adjusted_level_polygon)
			
			if not intersected_polygons.is_empty():
				for intersected_polygon in intersected_polygons:
					if not Geometry2D.is_polygon_clockwise(intersected_polygon):
						var collision_polygon := CollisionPolygon2D.new()
						collision_polygon.polygon = intersected_polygon
						add_child(collision_polygon)


func _register_collision_polygons(static_body: StaticBody2D) -> Array[CollisionPolygon2D]:
	var polygons: Array[CollisionPolygon2D]
	for child in static_body.get_children():
		if child is CollisionPolygon2D:
			polygons.append(child)
	level_collision_polygons = polygons
	return polygons
	
