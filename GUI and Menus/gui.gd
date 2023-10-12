extends Control

@onready var HPBar = $HPBar
@onready var RelicLabel = $RelicLabel
@onready var GoldLabel = $GoldLabel
func _ready():
	GoldLabel.text = str("fuck")

func _physics_process(delta):
	GoldLabel.text = str(Scores.GoldScore, " Gold")

func Update():
	print(Scores.GoldScore)
	GoldLabel.text = str(Scores.GoldScore, " Gold")
