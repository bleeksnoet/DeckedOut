extends StaticBody2D

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Global.is_dragging:
		visible = true
	else:
		visible = false
