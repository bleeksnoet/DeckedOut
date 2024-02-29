extends CharacterBody2D

@onready var LifeTime = $Lifetime

var Speed = 50

func _physics_process(delta):
	var direction = -1
	if direction:
		velocity.y = direction * Speed
		
	move_and_slide()


func _on_lifetime_timeout():
	Global.sun += 5
	dead()
	
func dead():
	queue_free()
