extends CharacterBody2D

var speed = 300
var accel = 150
var target = null

@onready var RunTimer = $RunafterTimer
@onready var LookTimer = $LookTimer
@onready var animtree = $AnimationTree
@onready var animplayer = $AnimationPlayer
@onready var animstate = animtree.get("parameters/playback")
@onready var DetectionCone = $Detectioncone
@onready var nav = $NavigationAgent2D

enum states{
	Stationary,
	Chase
}
var currentstate = states.Stationary
# Called when the node enters the scene tree for the first time.
func _ready():
	animstate.travel("Idle")

func _physics_process(delta):
	print(LookTimer.time_left)
	animtree.set("parameters/Idle/blend_position", velocity)
	animtree.set("parameters/Walking/blend_position", velocity)
	
	var direction = Vector2()
	
	if currentstate == states.Chase:
		LookTimer.stop()
		nav.target_position = target.global_position
		DetectionCone.look_at(target.global_position)
		animstate.travel("Walking")
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
	
	if currentstate == states.Stationary:
		if LookTimer.time_left == 0:
			LookTimer.start()
		animstate.travel("Idle")
		
	velocity = direction * speed
	
	move_and_slide()

func _on_detection_area_entered(area):
	target = area #me when i fucking GET YOU
	print(target)
	if currentstate != states.Chase:
		currentstate = states.Chase


#runtimer
func _on_timer_timeout():
	currentstate = states.Stationary
	DetectionCone.rotation_degrees = 0
	target = null


func _on_detection_area_exited(area):
	#timer currently keeps going even if you rentered the area, gotta fix that
	RunTimer.start()


func _on_look_timer_timeout():
	DetectionCone.rotation_degrees += 90
