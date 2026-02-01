class_name Lamp extends CharacterBody2D

@export var color : game_manager.color_enum = GameManager.color_enum.RED
@onready var bobby_collectable: BobbyCollectible = $BobbyCollectable
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var throwable: CharacterBody2D = $Throwable
@onready var brush_template: Sprite2D = $Brush
@onready var brush_scale : float = 2

var brush : Sprite2D

func _ready():
	bobby_collectable.collected.connect(receive_collected)
	match color:
		GameManager.color_enum.RED:
			sprite_2d.modulate = Color.RED
		GameManager.color_enum.GREEN:
			sprite_2d.modulate = Color.GREEN
		GameManager.color_enum.BLUE:
			sprite_2d.modulate = Color.BLUE
	draw_lantern()
	

func draw_lantern():
	#mask : Sprite = new
	#if game_manager.current_held is game_manager.
	if RoomManager.busy:
		return
	
	#duplicate lamp sprite 
	var sprite : Sprite2D = self.brush_template.duplicate()
	var gradientTex : GradientTexture2D = sprite.texture
	sprite.scale = sprite.scale * self.brush_scale
	sprite.visible = true
	#sprite.scale = sprite.scale.height * lamp.brush_scale
	#sprite.texture.resize(sprite.texture.get_width() * lamp.brush_scale, sprite.texture.get_height() * lamp.brush_scale)
	
	if not RoomManager.current_level:
		await RoomManager.level_ready
	brush = RoomManager.current_level.add_temp_mask(color, sprite )
	turn_on_lamp()

func _physics_process(delta: float) -> void:
	if brush:
		brush.position = position
	move_and_slide()

func turn_off_lamp():
	brush.visible = false

func turn_on_lamp():
	brush.visible = true

func receive_collected(obj_ref: Node):
	print("lamp received collected signal")
	game_manager.collect_item(game_manager.inventory_slot_type.LAMP, color, obj_ref)
	deactivate()

func deactivate():
	bobby_collectable.deactivate()
	print("deac'd")
	#sprite_2d.visible = false
	#self.disabled = true

func reactivate():
	#self.disabled = false
	throwable.reactivate()
	bobby_collectable.reactivate()
	sprite_2d.visible = true
