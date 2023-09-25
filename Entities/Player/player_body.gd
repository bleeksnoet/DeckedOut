extends CharacterBody2D

@export var walkspeed = 400  # speed in pixels/sec
@export var speedup = 200
@export var jumpspeed = 200
@onready var animtree = $AnimationTree
@onready var animplayer = $AnimationPlayer
@onready var JumpTimer = $JumpTimer
@onready var Collison = $PlayerCol
@onready var HPmanager = $HPmanager
@onready var animstate = animtree.get("parameters/playback")

var direction = Vector2.ZERO
var speed = walkspeed

enum states {
	Idle,
	Walking,
	Falling
}
var CurrentState = states.Idle

func _physics_process(delta):
	direction.x = Input.get_action_strength("Walk_East") - Input.get_action_strength("Walk_West")
	direction.y = Input.get_action_strength("Walk_South") - Input.get_action_strength("Walk_North")
	direction = direction.normalized()
	Walking()
	Idle()
	move_and_slide()
	print(HPmanager.current_health)

#can go to idle and jumping
func Walking():
	if CurrentState == states.Walking:
		speed = walkspeed
		animtree.set("parameters/Idle/blend_position", direction)
		animtree.set("parameters/Walk/blend_position", direction)
		animstate.travel("Walk")
		velocity = direction * speed

#state changers
		if direction == Vector2.ZERO:
			CurrentState = states.Idle
		if Input.is_action_just_pressed("Jump"):
			Jumping()#Jumping is not a state because otherwise the speed wont change

#Can go to walking and jumping
func Idle():
	if CurrentState == states.Idle:
		animstate.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,speedup)
		
#state changers
		if direction != Vector2.ZERO:
			CurrentState = states.Walking
		if Input.is_action_just_pressed("Jump"):
			Jumping() #Jumping is not a state because otherwise the speed wont change

#At the end of jump returns to Idle
func Jumping():
	Collison.disabled = true
	animstate.travel("Jump")
	if !JumpTimer.time_left > 0:
		JumpTimer.start()

func _on_jump_timer_timeout():
	speed = walkspeed
	Collison.disabled = false
	CurrentState = states.Idle

func _on_hpmanager_died():
	animplayer.play("Death")

func _on_dmg_checker_body_entered(body):
	HPmanager.damage(1)
