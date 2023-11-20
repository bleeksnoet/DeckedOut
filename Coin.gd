extends Node2D

@export var Worth = 1

var target = null
var speed = 100

@onready var Animplayer = $AnimationPlayer
@onready var nav = $NavigationAgent2D

func _ready():
	Animplayer.play("Spawnjump")
