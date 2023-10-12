extends Control

@onready var HPBar = $HPBar
@onready var RelicLabel = $RelicLabel
@onready var GoldLabel = $GoldLabel
var GoldScore = 0
var RelicScore = 0

signal GuiUpdates
# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready!")
	GoldLabel.text = str(GoldScore, " Gold")
	RelicLabel.text = str(RelicScore, " Relic(s)")


func _on_gui_updates():
	print(GoldScore)
	print(RelicScore)
	GoldLabel.text = str(GoldScore, " Gold")
	RelicLabel.text = str(RelicScore, " Relic(s)")
