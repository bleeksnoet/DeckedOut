extends CharacterBody2D

var target = preload("res://Entities/Loot/relic_drop.tscn")

@onready var NavAg = $NavigationAgent2D
@onready var particle = $GPUParticles2D
@onready var Lifetime = $Timer

var speed = 100

func _ready():
	NavAg.target_position = target.global_position - global_position
	Lifetime.start()

func _process(delta):
	var direction = Vector2()

	direction = NavAg.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = direction * speed
	move_and_slide()


func _on_timer_timeout():
	queue_free()
