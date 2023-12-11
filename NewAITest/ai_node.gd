extends CharacterBody2D

#all the nodes readied
@onready var Wallchkr = $Wallchecker
@onready var NavAg = $NavAG
@onready var Core = $"."

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

#finding out whoms'tve the target is
var target = null
var from_target = null
var distance = null
#select your AI!
enum Behaviourlist{none,chase} 
#dropdownlist for the enum above
@export var Behaviour = Behaviourlist.none
#speed!
@export var speed = 400
#when should the AI retreat?
@export var attack_range = 3
#le statelist(universal wow!!) :3
enum states {
	Idle,
	Chase,
	Attack,
	Searching,
	Returning
}
var currentstate = states.Idle
#player entered the cone of sight! lets check if the AI can *actually* see them
func _on_detection_area_area_entered(area):
	Wallchkr.target_position = area.global_position - Wallchkr.global_position
	if !Wallchkr.is_colliding():
		target = area
		from_target = target.global_position - Core.global_position
		distance = from_target.length()

func _physics_process(delta):
	var direction = Vector2()
	
	if Behaviour == Behaviourlist.none: return
	
	if Behaviour == Behaviourlist.chase:
		#making sure the AI wont crash the game instantly
		if target == null:
			currentstate = states.Searching
			print("guh??")
		if target != null:
			currentstate = states.Chase
			
		if currentstate == states.Chase:
			var buffer = 50
			
			var toPlayer = target.global_position - global_position
			distance = toPlayer.length()
			
			if distance > attack_range + buffer:
				NavAg.target_position = target.global_position
			elif distance < attack_range - buffer: #too close!! move to a certain distance
				var desiredDistance = attack_range * 1.5
				var oppositeDirection = -toPlayer.normalized()
				var destination = target.global_position + oppositeDirection * desiredDistance
				
				NavAg.target_position = destination
			
			direction = NavAg.get_next_path_position() - global_position
			direction = direction.normalized()

	#keep this at the bottom
	velocity = direction * speed
	move_and_slide()



#		if target == null:
#			currentstate = states.Returning
#		#running after the detected target
#		nav.target_position = target.global_position
#		DetectionCone.look_at(target.global_position)
#		animstate.travel("Walking")
#
#		direction = nav.get_next_path_position() - global_position
#		direction = direction.normalized()
#
#		velocity = direction * speed
