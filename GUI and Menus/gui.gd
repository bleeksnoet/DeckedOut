extends Control

@onready var HPBar = $HPBar
@onready var RelicLabel = $RelicLabel
@onready var GoldLabel = $GoldLabel
func _ready():
	GoldLabel.text = str("fuck")
	HPBar.max_value = Scores.MaxHealth

func _process(delta):
	GoldLabel.text = str(Scores.GoldScore, " Gold")
	HPBar.value = Scores.Health
