extends CharacterBody2D

var mainspeed = 400
@export var speed = 400  # speed in pixels/sec
@export var speedup = 200
@onready var animtree = $AnimationTree
@onready var animplayer = $AnimationPlayer
@onready var Collison = $Wallcol
@onready var HPmanager = $HPmanager
@onready var WeapSys = $WeaponSystem
@onready var DmgTimer = $DamageTimer
@onready var Hitbox = $Hitbox/CollisionShape2D
@onready var Sneaky = $Sneaky
@onready var animstate = animtree.get("parameters/playback")

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

func damagetaken():
	if inframes == false:
		print("hurt")
		HPmanager.damage(1)
		animstate.travel("Jump")
		DmgTimer.start()
		Hitbox.disabled = true
		Sneaky.monitorable = false
		Sneaky.monitoring = false
		Scores.Health = HPmanager.current_health
		inframes = true

func _on_hpmanager_died():
	CurrentState = states.Dead

func _on_damage_timer_timeout():
	inframes = false
	Hitbox.disabled = false

func _on_hitbox_area_entered(area):
	Scores.Health = HPmanager.current_health
	damagetaken()
