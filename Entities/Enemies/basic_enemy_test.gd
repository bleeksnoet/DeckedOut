extends CharacterBody2D

var speed = 300
var accel = 150
var target = null

@onready var nav = $NavigationAgent2D

enum states{
	Stationary,
	Chase
}
var currentstate = states.Stationary
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	var direction = Vector2()
	if currentstate == states.Chase:
		nav.target_position = target.global_position
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
	velocity = direction * speed
	
	move_and_slide()

func _on_detection_area_entered(area):
	target = area #me when i fucking GET YOU
	print(target)
	if currentstate != states.Chase:
		currentstate = states.Chase


func _on_timer_timeout():
	currentstate = states.Stationary
	target = null


func _on_detection_area_exited(area):
	$Timer.start()
