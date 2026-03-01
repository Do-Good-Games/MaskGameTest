class_name Lamp2D extends CharacterBody2D

@export var color : game_manager.color_enum = GameManager.color_enum.RED
@onready var bobby_collectable: BobbyCollectible = $BobbyCollectable
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var throwable: CharacterBody2D = $Throwable
@onready var brush_template: Sprite2D = $Brush
@onready var brush_scale : float = 2

##Fiona Lantern Logic Tweaks
@onready var fresh_lantern = true
@export_range (0,1) var max_glow = .30
@onready var glow: PointLight2D = $PointLight2D
@onready var lamp = $SubViewport/RedLamp



var brush : Sprite2D

func _ready():
	bobby_collectable.collected.connect(receive_collected)
	match color:
		#make the modulate COLOR + alpha or .5 ish #nope nvm doesnt work like that
		GameManager.color_enum.RED:
			sprite_2d.modulate = Color(.4,.10,-1,1)
			glow.color = Color.RED
		GameManager.color_enum.GREEN:
			sprite_2d.modulate = Color.GREEN
			glow.color = Color.GREEN
		GameManager.color_enum.BLUE:
			sprite_2d.modulate = Color.BLUE
			glow.color = Color.BLUE
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
	
	#freshness checker statement. 
	#Lamp starts off as FRESH & UNLIT in level
	#Becomes LIT and UNFRESH when u grab it and its in ur inventory
	if (fresh_lantern == true):
		turn_off_lamp()
	else:
		turn_on_lamp()

func _physics_process(delta: float) -> void:
	
	if brush:
		brush.position = position
	move_and_slide()

func turn_off_lamp():
	glow.energy = 0
	brush.visible = false

func turn_on_lamp():
	glow.energy = max_glow
	brush.visible = true

func receive_collected(obj_ref: Node):
	print("lamp received collected signal")
	fresh_lantern = false #no longer a fresh lantern
	print("lamp freshness = false.")
	game_manager.collect_item(game_manager.inventory_slot_type.LAMP, color, obj_ref)
	deactivate()

func deactivate():
	bobby_collectable.deactivate()
	print("deac'd")
	sprite_2d.visible = false

func reactivate():
	throwable.reactivate()
	bobby_collectable.reactivate()
	sprite_2d.visible = true
