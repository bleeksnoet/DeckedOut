extends CharacterBody2D

#all the nodes readied
@onready var Wallchkr = $Wallchecker
@onready var NavAg = $NavAG
@onready var Core = $"."
@onready var STimer = $SwitchTimer
@onready var Detector = $DetectionArea
@onready var spawnpoint = global_position
@onready var DetectTimer = $DetectionTimer
@onready var WanderTimer = $WanderTimer
var Standing = false
#health and damagio
@export var Tiers = Tier

var damage = 5
var HP = 5

enum Tier {
	T1,
	T2,
	T3,
	T4,
	T5,
	T6
}

var Tier_info = {
	Tier.T1: {HP: 5, damage: 5},
	Tier.T2: {HP: 5, damage: 10},
	Tier.T3: {HP: 5, damage: 15},
	Tier.T4: {HP: 5, damage: 20},
	Tier.T5: {HP: 5, damage: 25},
	Tier.T6: {HP: 5, damage: 30},
}

#finding out whoms'tve the w is
var target = null
var from_target = null
var distance = null
#select your AI!, chase is an melee ai that roams and runs after the player, sentry chases the player and returns once its done
enum Behaviourlist{none,chase,sentry} 
#dropdownlist for the enum above
@export var Behaviour = Behaviourlist.none
#speed!
@export var originalSpeed = 390
var speed = originalSpeed
#when should the AI retreat?
@export var attack_range = 3

@export var Roam_Radius = 10
#le statelist(universal wow!!) :3
enum states {
	Idle,
	Chase,
	Attack,
	Searching,
	Returning,
	Roaming
}
var currentstate = states.Idle


func _ready():
	randomize()
	var spawnpoint = global_position
	
	if Behaviour == Behaviourlist.chase:
		currentstate = states.Roaming
#		if global_position == spawnpoint:
#			currentstate = states.Idle
#		else:
#			currentstate = states.Returning

#player entered the cone of sight! lets check if the AI can *actually* see them
func _on_detection_area_area_entered(area):
	Wallchkr.target_position = area.global_position - Wallchkr.global_position
	if !Wallchkr.is_colliding():
		target = area
		from_target = target.global_position - Core.global_position
		distance = from_target.length()


@warning_ignore("unused_parameter")
func _physics_process(delta):
	$stateshower.text = str(currentstate)
	var direction = Vector2()
	
	if Behaviour == Behaviourlist.none: return
	
	if Behaviour == Behaviourlist.chase:
		#making sure the AI wont crash the game instantly
		if target == null:
			Detector.look_at(global_position+direction)
		else:
			Detector.look_at(target.global_position)
			currentstate = states.Chase
		
		if currentstate == states.Chase:
			if target == null:
				if DetectTimer.is_stopped():
					DetectTimer.start()
			else:
				var toPlayer = target.global_position - global_position
				distance = toPlayer.length()

				# If the distance is greater than attack_range, navigate towards the player
				if distance > attack_range && Standing == false:
					NavAg.target_position = target.global_position
					speed = originalSpeed
				elif distance < attack_range:
					# If too close, navigate away from the player within the attack_range
					var desiredDistance = attack_range * 1.5  # Adjust the multiplier as needed
					var oppositeDirection = -toPlayer.normalized()
					var destination = target.global_position + oppositeDirection * desiredDistance
					NavAg.target_position = destination
					@warning_ignore("integer_division")
					speed = originalSpeed/2
					Standing = true
					if STimer.is_stopped():
						STimer.start()
			
			direction = NavAg.get_next_path_position() - global_position
			direction = direction.normalized()

		if currentstate == states.Returning:
			NavAg.target_position = spawnpoint
			direction = NavAg.get_next_path_position() - global_position
			direction = direction.normalized()
			
			speed = originalSpeed/2
			
			Detector.look_at(global_position + direction)
			
			if global_position.distance_to(spawnpoint) < 5:
				currentstate = states.Idle
				velocity = Vector2.ZERO
				speed = originalSpeed

		if currentstate == states.Roaming:
			if WanderTimer.is_stopped():
				var target_vector = Vector2(randf_range(-Roam_Radius, Roam_Radius), randf_range(-Roam_Radius, Roam_Radius))
				spawnpoint = spawnpoint + target_vector
				WanderTimer.start(randf_range(1,7))
			
			NavAg.target_position = spawnpoint
			direction = NavAg.get_next_path_position() - global_position
			direction = direction.normalized()
			
			speed = originalSpeed/2
			
			Detector.look_at(global_position + direction)


	#keep this at the bottom
	if global_position.distance_to(NavAg.target_position) < 5:
		velocity = Vector2.ZERO
	else:
		velocity = direction * speed
	move_and_slide()


func _on_switch_timer_timeout():
	Standing = false


func _on_detection_area_area_exited(area):
	if DetectTimer.is_stopped():
		DetectTimer.start()


func _on_detection_timer_timeout():
	if Behaviour == Behaviourlist.chase:
		spawnpoint = global_position
		currentstate = states.Roaming
