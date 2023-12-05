extends CharacterBody2D

var mainspeed = 400
@export var speed = 400  # speed in pixels/sec
@export var speedup = 200

@onready var animtree = $AnimationTree
@onready var animplayer = $AnimationPlayer
@onready var Collison = $Wallcol
@onready var HPmanager = $HPmanager
@onready var WeapSys = $WeaponSystem
@onready var Hitbox = $Hitbox/CollisionShape2D
@onready var Sneaky = $Sneaky
@onready var animstate = animtree.get("parameters/playback")

#incoming damage stuff
var dmgindicator = preload("res://GUI and Menus/dmg_indicator.tscn")
enum dmg_value {
	T0,
	T1,
	T2,
	T3,
	T4,
	T5,
	T6
}
var incomingdmg = dmg_value.T0
var dmgtaken
var dmgtxt

var direction = Vector2.ZERO
enum states {
	Idle,
	Walking,
	Sneaking,
	Striking,
	Dead
}

var inframes = false
var CurrentState = states.Idle

func _ready():
	Scores.MaxHealth = HPmanager.max_health
	Scores.Health = HPmanager.current_health
	
func _physics_process(delta):
	direction.x = Input.get_action_strength("Walk_East") - Input.get_action_strength("Walk_West")
	direction.y = Input.get_action_strength("Walk_South") - Input.get_action_strength("Walk_North")
	direction = direction.normalized()
	var mpos = get_global_mouse_position()
	$VisionCone.look_at(mpos)
	
	Striking()
	Walking()
	Sneaking()
	Idle()
	dead()
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
#WIP
func Striking():
	if CurrentState == states.Striking:
		animstate.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,speedup)
		
#state changers
		if direction != Vector2.ZERO:
			CurrentState = states.Walking

func dead():
	if CurrentState == states.Dead:
		animstate.travel("Death")
		$Sneaky/maincol.disabled = true
		$Sneaky/Sneakcol.disabled = true
		Hitbox.disabled = true
		velocity = velocity.move_toward(Vector2.ZERO,speedup)

func dmgcalc():
	if incomingdmg == dmg_value.T1:
		dmgtaken = 5
		dmgtxt = "oops"
		damagetaken()
	if incomingdmg == dmg_value.T2:
		dmgtaken = 10
		dmgtxt = "OOPS"
		damagetaken()

func damagetaken():
		print("hurt")
		HPmanager.damage(dmgtaken)
		HPmanager.enable_invulnerability(true, 1)
		animstate.travel("Jump")
		Scores.Health = HPmanager.current_health
		spawndmgindicator()

func spawndmgindicator():
	var dmgi = dmgindicator.instantiate()
	add_child(dmgi)
	dmgi.scale *=2
	dmgi.position = $Sprite2D.position + Vector2(randf_range(-1, 1), randf_range(-1, 1))
	dmgi.label.text = str(dmgtxt)

func _on_hpmanager_died():
	CurrentState = states.Dead

func _on_hitbox_area_entered(area):
	print(area)
	if area.is_in_group("T1"): incomingdmg = dmg_value.T1
	if area.is_in_group("T2"): incomingdmg = dmg_value.T2
	Scores.Health = HPmanager.current_health
	dmgcalc()
