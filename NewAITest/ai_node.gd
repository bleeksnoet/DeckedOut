extends Node2D

#all the nodes readied
@onready var Wallchkr = $Wallchecker
var detecting
var AREA = null


#player entered the cone of sight! lets check if the AI can *actually* see them
func _on_detection_area_area_entered(area):
	Wallchkr.look_at(area.global_position)
