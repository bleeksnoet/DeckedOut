extends Camera2D


var zoomspeed = 0.1
var zoommarg = 0.3

var min_zoom = 1
var max_zoom = 4.0

var zoompos = Vector2()
var zoomfac = 1.0

func _process(delta):
	zoom.x = lerp(zoom.x, zoom.x * zoomfac, zoomspeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomfac, zoomspeed * delta)
	
	zoom.x = clamp(zoom.x, min_zoom, max_zoom)
	zoom.y = clamp(zoom.y, min_zoom, max_zoom)
	
func _input(event):
	if abs(zoompos.x - get_global_mouse_position().x) > zoommarg:
		zoomfac = 1.0
	if abs(zoompos.y - get_global_mouse_position().y) > zoommarg:
		zoomfac = 1.0

	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom.x += 0.1
				zoom.y += 0.1
				zoompos = get_global_mouse_position()
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom.x -= 0.1
				zoom.y -= 0.1
				zoompos = get_global_mouse_position()
