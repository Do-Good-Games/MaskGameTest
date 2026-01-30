extends Sprite2D

@export var epsilon := 10.0
@export var body: StaticBody2D
@export var level_collision_polygons: Array[CollisionPolygon2D]
@export var rect_size := Vector2(100, 1000)

# NOTE: This is mostly a test of the logic, this script should probably live on each geometry layer not the spritee
# Waiting to set that up until we have the shader set up properly because idk if we'll be using sprites for that
# Also there's some weirdness with how it lines up, the outer edges are like 10 pixels too high
# but the inner edges are exactly right?


func _ready() -> void:
	var image := texture.get_image()
	
	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(image)
	
	generate_collision(bitmap)

func generate_collision(bitmap: BitMap) -> void:
	for x_index: int in ceil(texture.get_size().x / rect_size.x):
		for y_index: int in ceil(texture.get_size().y / rect_size.y):
			var x_start: float = x_index * rect_size.x
			var y_start: float = y_index * rect_size.y
			var start_pos := Vector2(x_start, y_start)
			
			var x_size: float = min(rect_size.x, texture.get_size().x - x_start)
			var y_size: float = min(rect_size.y, texture.get_size().y - y_start)
			var size := Vector2(x_size, y_size)
			generate_collision_region(bitmap, start_pos, size)


func generate_collision_region(bitmap: BitMap, start_pos: Vector2, size: Vector2) -> void:
	var polys := bitmap.opaque_to_polygons(
		Rect2(start_pos, size), 
		epsilon
	)
	
	for poly in polys:
		for level_collison_polygon in level_collision_polygons:
			var level_polygon := level_collison_polygon.polygon
			var adjusted_poly: PackedVector2Array = []
			for point in poly:
				adjusted_poly.append(point + start_pos) # Convert to global space too
			
			var adjusted_level_polygon: PackedVector2Array = []
			for point in level_polygon:
				adjusted_level_polygon.append(level_collison_polygon.to_global(point))
			
			var intersected_polygons := Geometry2D.intersect_polygons(adjusted_poly, adjusted_level_polygon)
			
			if not intersected_polygons.is_empty():
				for intersected_polygon in intersected_polygons:
					if not Geometry2D.is_polygon_clockwise(intersected_polygon):
						var collision_polygon := CollisionPolygon2D.new()
						collision_polygon.polygon = intersected_polygon
						#collision_polygon.position = start_pos
						body.add_child(collision_polygon)
						
						if centered:
							collision_polygon.position -= bitmap.get_size() / 2.0
					else:
						print("clockwise")
