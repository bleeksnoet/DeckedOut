extends Sprite2D

var dragging = false
var OriginalPosition = Vector2.ZERO
var MouseIn = false
var PlantScene = preload("res://plants/CurrencyPlant.tscn")
var plantable = false

func _ready():
	OriginalPosition = position

func _input(event):
	if Input.is_action_pressed("Click") and MouseIn == true:
		if Global.sun >= 5:
			dragging = true
		else:
			print("Not enough seeds")
	elif Input.is_action_just_released("Click") and dragging == true:
		dragging = false
		SpawnPlant(get_global_mouse_position())
		position = OriginalPosition

func _process(delta):
	if dragging == true:
		position = get_global_mouse_position() - offset

func _on_area_2d_mouse_entered():
	MouseIn = true
	set_scale(Vector2(0.30,0.30))

func _on_area_2d_mouse_exited():
	MouseIn = false
	set_scale(Vector2(0.25,0.25))

func SpawnPlant(position):
	var PlantInstance = PlantScene.instantiate()
	
	var SnappedPosition = Vector2(int(position.x / 64) * 64 + 32,int(position.y / 64) * 64 + 32)
	PlantInstance.global_position = SnappedPosition
	
	if plantable == true:
		get_tree().get_root().add_child(PlantInstance)
		Global.sun -= 5
		plantable = false
	else:
		print("unable to plant")


func _on_area_2d_area_entered(area):
	if area.is_in_group("Grass"):
		plantable = true
		print("planting possible")


func _on_area_2d_area_exited(area):
	if !area.is_in_group("Grass"):
		plantable = false
		print("planting impossible")
