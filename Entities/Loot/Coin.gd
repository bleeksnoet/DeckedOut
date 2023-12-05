extends CharacterBody2D

@export var worth = 1
var speed = 500
var accel = 150
var target = null

@onready var animplayer = $AnimationPlayer
@onready var nav = $NavigationAgent2D

enum states{
	Stationary,
	Chase
}
var currentstate = states.Stationary
# Called when the node enters the scene tree for the first time.
func _ready():
	animplayer.play("Spawnjump")

func _physics_process(delta):
	var direction = Vector2()
	
	if currentstate == states.Chase:
		nav.target_position = target.global_position
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
	
		
	velocity = direction * speed
	
	move_and_slide()

func _on_player_seeker_area_entered(area):
	target = area #me when i fucking GET YOU
	if currentstate != states.Chase:
		currentstate = states.Chase

func _on_collision_area_entered(area):
	Scores.GoldScore += worth
	queue_free()
