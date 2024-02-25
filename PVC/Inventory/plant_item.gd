extends Node2D

var draggable = false
var IsInsideDropable = false
var bodyRef
var offset: Vector2
var initialPos: Vector2

func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("Click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
		if Input.is_action_pressed("Click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("Click"):
			Global.is_dragging = false
			var tween = get_tree().create_tween()
			if IsInsideDropable:
				tween.tween_property(self, "position",bodyRef.global_position,0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_body_entered(body):
	if body.is_in_group("Ground"):
		IsInsideDropable = true
		bodyRef = body

func _on_area_2d_body_exited(body):
	if body.is_in_group("Ground"):
		IsInsideDropable = false

func _on_area_2d_mouse_entered():
	if not Global.is_dragging:
		draggable = true
		scale = Vector2(1.05,1.05)

func _on_area_2d_mouse_exited():
	if not Global.is_dragging:
		draggable = false
		scale = Vector2(1,1)
