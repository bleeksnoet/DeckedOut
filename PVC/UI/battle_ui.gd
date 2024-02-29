extends Control

@onready var CurrencyLabel = $Label

func _ready():
	CurrencyLabel.text = str("Seeds: ", Global.sun)
func _process(delta):
	CurrencyLabel.text = str("Seeds: ", Global.sun)
