extends CharacterBody2D

var mainspeed = 400
@export var speed = 400  # speed in pixels/sec
@export var speedup = 200
@onready var animtree = $AnimationTree
@onready var animplayer = $AnimationPlayer
@onready var Collison = $Wallcol
@onready var HPmanager = $HPmanager
@onready var HPBar = $HPBar
@onready var animstate = animtree.get("parameters/playback")

var direction = Vector2.ZERO
enum states {
	Idle,
	Walking,
	Sneaking
}
var CurrentState = states.Idle

func _ready():
	HPBar.max_value = HPmanager.max_health

func _physics_process(delta):
	direction.x = Input.get_action_strength("Walk_East") - Input.get_action_strength("Walk_West")
	direction.y = Input.get_action_strength("Walk_South") - Input.get_action_strength("Walk_North")
	direction = direction.normalized()
	
	Walking()
	Sneaking()
	Idle()
	move_and_slide()

func Walking():
	if CurrentState == states.Walking:
		animtree.set("parameters/Idle/blend_position", direction)
		animtree.set("parameters/Walk/blend_position", direction)
		animstate.travel("Walk")
		velocity = direction * speed

#state changers
		if direction == Vector2.ZERO:
			CurrentState = states.Idle

func Sneaking():
	if Input.is_action_pressed("Sneak"):
		speed = speedup
		$Sneaky/maincol.disabled = true
		$Sneaky/Sneakcol.disabled = false
	else:
		speed = mainspeed
		$Sneaky/maincol.disabled = false
		$Sneaky/Sneakcol.disabled = true

func Idle():
	if CurrentState == states.Idle:
		animstate.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,speedup)
		
#state changers
		if direction != Vector2.ZERO:
			CurrentState = states.Walking

func _on_hpmanager_died():
	print("yes")
	animstate.travel("Death")

func _on_dmg_checker_body_entered(body):
	HPBar.value = HPmanager.current_health
	HPmanager.damage(1)

func _on_jumpcol_checker_body_entered(body):
	HPBar.value = HPmanager.current_health
	HPmanager.damage(HPmanager.max_health)
