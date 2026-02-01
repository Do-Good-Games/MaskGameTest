class_name Animation_Button extends Node

@export_category("Animation Settings")
@export var hover_duration: float = 0.2

@export_category("Rotation")
@export var enable_rotation: bool = true
@export var counter_clockwise: bool = false
@export var rotation_deg: float = 2

@export_category("Scale")
@export var enable_scale: bool = true
@export var scale_min: float = 1
@export var scale_max: float = 1.02

var target: Control = null

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-#
func _ready() -> void:
	var parent_node: Node = get_parent()
	if parent_node is Control:
		target = parent_node as Control
	else:
		push_error("This guy must be a child of a Control node.")
		return

	# center pivot for scale/rotation
	target.pivot_offset = target.size / 2

	# initial states
	if enable_scale:
		target.scale = Vector2(scale_min, scale_min)

	target.mouse_entered.connect(_on_hover_enter)
	target.mouse_exited.connect(_on_hover_exit)


#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-#

func _on_hover_enter() -> void:
	animate_hover(true)

func _on_hover_exit() -> void:
	animate_hover(false)

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-#
func animate_hover(is_enter: bool) -> void:
	if target == null:
		return
	
	if get_tree() == null:
		push_warning("SceneTree is null. No tween created. Probablye due to loading a new scene at the same time")
		return

	var tween: Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	if enable_rotation:
		var target_angle: float
		if is_enter:
			if counter_clockwise:
				target_angle = -rotation_deg
			else:
				target_angle = rotation_deg
		else:
			target_angle = 0.0  # return to neutral when not hovered

		tween.tween_property(target, "rotation_degrees", target_angle, hover_duration)
	
	if enable_scale:
		var target_scale: float
		if is_enter:
			target_scale = scale_max
		else:
			target_scale = scale_min

		tween.tween_property(target, "scale", Vector2(target_scale, target_scale), hover_duration)
