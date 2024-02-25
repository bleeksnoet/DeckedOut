extends CharacterBody2D

var speed = 300
var accel = 150

var target = null

enum ConeAngle{North,East,South,West} 

@export var Current_angle = ConeAngle.North
@onready var RunTimer = $RunafterTimer
@onready var DetectionCone = $NavSys/Detection
@onready var nav = $NavSys/NavAG

enum states{
	Stationary,
	Chase
}
var currentstate = states.Stationary
# Called when the node enters the scene tree for the first time.
func _ready():
	match Current_angle:
		ConeAngle.North:
			DetectionCone.rotation_degrees = 270
		ConeAngle.East:
			DetectionCone.rotation_degrees = 0
		ConeAngle.South:
			DetectionCone.rotation_degrees = 90
		ConeAngle.West:
			DetectionCone.rotation_degrees = 180

func _physics_process(delta):
#	animtree.set("parameters/Idle/blend_position", velocity)
	var direction = Vector2()
	
	if currentstate == states.Chase:
		nav.target_position = target.global_position
		DetectionCone.look_at(target.global_position)
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
	
	velocity = direction * speed
	
	move_and_slide()

func snap_cone_angle():
	var current_angle = DetectionCone.global_rotation_degrees
	var snapped_angle = nearest_angle(current_angle)
	DetectionCone.rotation_degrees = snapped_angle

func nearest_angle(angle):
	var remainder = int(angle) % 90
	if remainder < 45:
		return floor(angle/90)*90
	else:
		return ceil(angle/90)*90

func _on_detection_area_entered(area):
	if RunTimer.time_left != 0:
		RunTimer.stop()
	target = area #me when i fucking GET YOU
	if currentstate != states.Chase:
		currentstate = states.Chase
func _on_detection_area_exited(area):
	RunTimer.start()
func _on_runafter_timer_timeout():
	currentstate = states.Stationary
	target = null
	snap_cone_angle()
