extends Node2D

signal detected()

# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Ray1.is_colliding() or $Ray2.is_colliding() or $Ray3.is_colliding() or $Ray4.is_colliding() or $Ray5.is_colliding():
		detected.emit()

func _on_detection_area_entered(area):
	detected.emit()
