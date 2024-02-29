extends Node2D

@onready var BarrelEnd = $BarrelEnd
@onready var AttackCooldown = $AttackCooldown

@export var Seed = preload("res://projectiles/seed.tscn")

func shoot():
	var seed = Seed.instantiate()
	seed.position = BarrelEnd.global_position
	get_tree().get_root().add_child(seed)
	

func _on_attack_cooldown_timeout():
	shoot()
	print("seeb")
