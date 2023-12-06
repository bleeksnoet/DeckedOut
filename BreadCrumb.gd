extends Area2D

#the bread has rotten!!
func _on_lifetime_timeout():
	queue_free()
