extends Node2D

@onready var EnemyDetector = $EnemyAreaDetector
@onready var BarrelEnd = $BarrelEnd
@onready var AttackCooldown = $AttackCooldown

@export var Bullet = preload("res://projectiles/bullet.tscn")

func _physics_process(delta):
	if $EnemyDetector.is_colliding():
		var col = $EnemyDetector.get_collider()
		if col is Area2D:
			if col.is_in_group("Enemy"):
				if AttackCooldown.time_left <= 0:
					AttackCooldown.start()
			else:
				AttackCooldown.stop()

func shoot():
	var bullet = Bullet.instantiate()
	bullet.transform = BarrelEnd.global_transform
	get_tree().get_root().add_child(bullet)
	

func _on_attack_cooldown_timeout():
	shoot()
