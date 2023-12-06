extends Area2D

@onready var animplayer = $AnimationPlayer

func _ready():
	if !animplayer.is_playing():
		animplayer.play("Decay")
#the bread has rotten!!
func _on_lifetime_timeout():
	queue_free()
