extends CharacterBody2D

var Health = 8
@onready var Hitbox = $HitBox

const SPEED = 10.0 #20 seems good

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = -1
	if direction:
		velocity.x = direction * SPEED

	move_and_slide()


func _on_hit_box_activator_area_entered(area):
	Hitbox.set_deferred("monitorable", true)
	#print("Hitbox On")


func _on_hit_box_area_entered(area):
	if Health >= 0:
		Health -= 1
	else:
		queue_free()
