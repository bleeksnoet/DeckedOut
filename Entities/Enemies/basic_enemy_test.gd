extends CharacterBody2D

var speed = 300
var accel = 150
var target = null
@export_enum("North","East","South","West") var ConeAngle

@onready var RunTimer = $RunafterTimer
@onready var LookTimer = $LookTimer
@onready var animtree = $AnimationTree
@onready var animplayer = $AnimationPlayer
@onready var animstate = animtree.get("parameters/playback")
@onready var DetectionCone = $Detectioncone
@onready var nav = $NavigationAgent2D
@onready var SoundTimer = $SoundTimer

enum states{
	Stationary,
	Chase
}
var currentstate = states.Stationary
# Called when the node enters the scene tree for the first time.
func _ready():
	if ConeAngle == "North":
		DetectionCone = 360

func _physics_process(delta):
#	animtree.set("parameters/Idle/blend_position", velocity)
	animtree.set("parameters/Walking/blend_position", velocity)
	var direction = Vector2()
	
	if currentstate == states.Chase:
		if SoundTimer.time_left == 0:
			SoundTimer.start()
		LookTimer.stop()
		nav.target_position = target.global_position
		DetectionCone.look_at(target.global_position)
		animstate.travel("Walking")
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
	
	if currentstate == states.Stationary:
		SoundTimer.stop()
		if LookTimer.time_left == 0:
			LookTimer.start()
		
	velocity = direction * speed
	
	move_and_slide()

func emit_sound():
	$AnimatedSprite2D.play("Dust_Trail")

func _on_detection_area_entered(area):
	if RunTimer.time_left != 0:
		RunTimer.stop()
	target = area #me when i fucking GET YOU
	if currentstate != states.Chase:
		currentstate = states.Chase


#runtimer
func _on_timer_timeout():
	currentstate = states.Stationary
	animstate.travel("Idle_east")
	DetectionCone.rotation_degrees = ConeAngle
	target = null


func _on_detection_area_exited(area):
	RunTimer.start()

func _on_sound_timer_timeout():
	emit_sound()
