extends CharacterBody2D

@export var walkspeed = 400  # speed in pixels/sec
@export var speedup = 200
@export var jumpspeed = 200
@onready var animtree = $AnimationTree
@onready var animplayer = $AnimationPlayer
@onready var JumpTimer = $JumpTimer
@onready var Collison = $Wallcol
@onready var HPmanager = $HPmanager
@onready var JumpCol = $JumpcolChecker/JumpCol
@onready var HPBar = $HPBar
@onready var animstate = animtree.get("parameters/playback")

var direction = Vector2.ZERO
var speed = walkspeed
enum states {
	Idle,
	Walking,
	Falling
}
var CurrentState = states.Idle

func _ready():
	HPBar.max_value = HPmanager.max_health

func _physics_process(delta):
	direction.x = Input.get_action_strength("Walk_East") - Input.get_action_strength("Walk_West")
	direction.y = Input.get_action_strength("Walk_South") - Input.get_action_strength("Walk_North")
	direction = direction.normalized()
	
	Walking()
	Idle()
	move_and_slide()

#can go to idle and jumping
func Walking():
	if CurrentState == states.Walking:
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
	speed = jumpspeed
	JumpCol.disabled = true
	animstate.travel("Jump")
	if !JumpTimer.time_left > 0:
		JumpTimer.start()

func _on_jump_timer_timeout():
	speed = walkspeed
	JumpCol.disabled = false
	CurrentState = states.Idle

func _on_hpmanager_died():
	print("yes")
	animstate.travel("Death")

func _on_dmg_checker_body_entered(body):
	HPBar.value = HPmanager.current_health
	HPmanager.damage(1)


func _on_jumpcol_checker_body_entered(body):
	HPBar.value = HPmanager.current_health
	HPmanager.damage(HPmanager.max_health)
