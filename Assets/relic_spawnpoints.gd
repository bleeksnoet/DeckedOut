extends Node2D

@onready var SP1 = $Spawnpoint1
@onready var SP2 = $Spawnpoint2
@onready var SP3 = $Spawnpoint3
@onready var SP4 = $Spawnpoint4
@onready var SP5 = $Spawnpoint5
@onready var RD = $RelicDrop
#spots that the relic can spawn on
var RelicPoints = []
#
func _ready():
	randomize()
	RelicPoints = [
	SP1,
	SP2,
	SP3,
	SP4,
	SP5
	]
	# picking a spot for it to spawn
	var chosen_relicpoint_index = randi() % RelicPoints.size()
	var chosen_relicpoint = RelicPoints[chosen_relicpoint_index]
	RD.position = chosen_relicpoint.position
