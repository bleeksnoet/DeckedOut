extends CharacterBody2D

@export var speed = 400  # speed in pixels/sec
@export var speedup = 200
@onready var animtree = $AnimationTree
@onready var animplayer = $AnimationPlayer
@onready var animstate = animtree.get("parameters/playback")

var direction = Vector2.ZERO

func _physics_process(delta):
	movement()
	move_and_slide()

func movement():
	direction.x = Input.get_action_strength("Walk_East") - Input.get_action_strength("Walk_West")
	direction.y = Input.get_action_strength("Walk_South") - Input.get_action_strength("Walk_North")
	direction = direction.normalized()
	
	if direction != Vector2.ZERO:
		animtree.set("parameters/Idle/blend_position", direction)
		animtree.set("parameters/Walk/blend_position", direction)
		animstate.travel("Walk")
		velocity = direction * speed
	else:
		animstate.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,speedup)
	
	
	if Input.is_action_just_pressed("Jump"):
		pass
