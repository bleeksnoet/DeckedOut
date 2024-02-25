extends CharacterBody2D

var SPEED = 500

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = 1
	if direction:
		velocity.x = direction * SPEED

	move_and_slide()


func _on_area_2d_area_entered(area):
	queue_free()
