extends Node2D

#all the nodes readied
@onready var Wallchkr = $Wallchecker

#player entered the cone of sight! lets check if the AI can *actually* see them
func _on_detection_area_area_entered(area):
	Wallchkr.target_position = area.global_position - Wallchkr.global_position


#	Wallchkr.look_at(area.global_position)
#	var size = Wallchkr.get_collision_point()
#	print(Wallchkr.get_collision_point())
