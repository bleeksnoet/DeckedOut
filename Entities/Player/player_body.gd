extends CharacterBody2D

@export var speed = 400  # speed in pixels/sec

func _physics_process(delta):
	var direction = Input.get_vector("Walk_West", "Walk_East", "Walk_North", "Walk_South")
	velocity = direction * speed

	move_and_slide()
