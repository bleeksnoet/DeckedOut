extends Sprite2D

var relic_amount = 0
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if Scores.difficulty == 1:
		relic_amount = rng.randi_range(5, 20)

func _on_area_2d_body_entered(body):
	Scores.RelicScore += relic_amount
	queue_free()
