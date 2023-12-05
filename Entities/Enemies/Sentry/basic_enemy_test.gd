extends CharacterBody2D

#setting up speed
var speed = 350
var walkspeed = 150
var accel = 150
#prepping target seeking
var target = null
#prepping spawnpoint of the AI so it can return to it
var spawnspot = global_position

#list to decide which way the enemy looks at the start of the game
enum ConeAngle{North,East,South,West} 
#dropdownlist for the enum above
@export var Current_angle = ConeAngle.North
#amount of damage this fucker deals
@export var damage = 1

@onready var StrikingTimer = $StrikingTimer
@onready var RunTimer = $RunafterTimer
@onready var animtree = $AnimationTree
@onready var animplayer = $AnimationPlayer
@onready var animstate = animtree.get("parameters/playback")
@onready var DetectionCone = $NavSys/RotatoNodo
@onready var nav = $NavSys/NavAG
@onready var Attackspr = $NavSys/RotatoNodo/AttackSprite
@onready var strikebox = $NavSys/RotatoNodo/StrikeBox/CollisionShape2D
@onready var inrangesb = $NavSys/RotatoNodo/InrangeSB/CollisionShape2D
@onready var walchk = $NavSys/RotatoNodo/Detection/Wallchecker


enum states{
	Stationary,
	Chase,
	Returning,
	Striking
}

#var to set the starting cone rotation of the AI
var OGconeROT
var currentstate = states.Stationary
# Called when the node enters the scene tree for the first time.
func _ready():
	#determining the spawnspot of the AI
	spawnspot = global_position
	#setting the cone angle to the result in the dropdown menu
	match Current_angle:
		ConeAngle.North:
			DetectionCone.rotation_degrees = 270
		ConeAngle.East:
			DetectionCone.rotation_degrees = 0
		ConeAngle.South:
			DetectionCone.rotation_degrees = 90
		ConeAngle.West:
			DetectionCone.rotation_degrees = 180
	#setting original degrees for later
	OGconeROT = DetectionCone.rotation_degrees

func _physics_process(delta):
	#making sure the animation is correct to the direction the AI walks to
	animtree.set("parameters/Walking/blend_position", velocity)
	var direction = Vector2()

	if currentstate == states.Chase:
		#running after the detected target
		nav.target_position = target.global_position
		DetectionCone.look_at(target.global_position)
		animstate.travel("Walking")
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = direction * speed
	
	if currentstate == states.Striking:
		velocity = Vector2.ZERO
		Attackspr.play("AttackAnim")
		strikebox.disabled = false
		
	if currentstate == states.Returning:
		#returning home
		animtree.set("parameters/Walking/blend_position", velocity)
		
		nav.target_position = spawnspot
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = direction * walkspeed
		
		DetectionCone.look_at(global_position + direction)
		
		if global_position.distance_to(spawnspot) < 5:
			animstate.travel("Idle_south")
			currentstate = states.Stationary
			velocity = Vector2.ZERO
			DetectionCone.rotation_degrees = OGconeROT

	move_and_slide()

#both snap cone angle and nearest angle are no longer used but banger code for later
#func snap_cone_angle():
#	var current_angle = DetectionCone.global_rotation_degrees
#	var snapped_angle = nearest_angle(current_angle)
#	DetectionCone.rotation_degrees = snapped_angle
#
#func nearest_angle(angle):
#	var remainder = int(angle) % 90
#	if remainder < 45:
#		return floor(angle/90)*90
#	else:
#		return ceil(angle/90)*90

#checking if a viable target entered the view of the AI
func _on_detection_area_entered(area):
	if !walchk.is_colliding():
		if RunTimer.time_left != 0:
			RunTimer.stop()
		target = area #me when i fucking GET YOU
		if currentstate != states.Chase:
			currentstate = states.Chase
	#If the AI lost track of their target
func _on_timer_timeout():
	currentstate = states.Returning
	target = null
#Starting the runtimer once their target leaves their cone
func _on_detection_area_exited(area):
	RunTimer.start()
#once the player is in range... strike!
func _on_inrange_sb_area_entered(area):
	StrikingTimer.start()
	currentstate = states.Striking

func _on_striking_timer_timeout():
	currentstate = states.Chase
	strikebox.disabled = true
