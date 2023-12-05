extends Node2D

@export var speed = 30
@export var friction = 15
var shift_dir = Vector2.ZERO
@onready var label = $Label

func _ready():
	shift_dir = Vector2(randf_range(-5, 5), randf_range(-5, 5))

func _process(delta):
	global_position += speed * shift_dir * delta
	speed = max(speed - friction * delta, 0)
