extends Node2D

#all the nodes readied
@onready var Wallchkr = $Wallchecker

#health and damagio
@export var damage = 5
@export var HP = 5

#finding out whoms'tve the target is
var target = null

#select your AI!
enum Behaviourlist{none,chase} 
#dropdownlist for the enum above
@export var Behaviour = Behaviourlist.none


#player entered the cone of sight! lets check if the AI can *actually* see them
func _on_detection_area_area_entered(area):
	Wallchkr.target_position = area.global_position - Wallchkr.global_position
	if !Wallchkr.is_colliding():
		print("not colliding!")
		target = area

func _physics_process(delta):
	pass
