extends Node2D

@export var food_gain : int

func _ready() -> void:
	GameManager.on_day_start.connect(start_day_behavior)
	GameManager.on_night_start.connect(end_day_behavior)

func start_day_behavior():
	GameManager.food_changed(food_gain)
	pass

func end_day_behavior():
	pass
