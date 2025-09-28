extends Node2D

@export var food_gain : int
@export var popup_lifetime = 1
@onready var popup_holder = $PopupPoint

func _ready() -> void:
	GameManager.on_day_start.connect(start_day_behavior)
	GameManager.on_night_start.connect(end_day_behavior)

func start_day_behavior():
	GameManager.food_changed(food_gain)
	var food_string = "+" + str(food_gain) + " food"
	GameManager.popup_manager.do_popup(popup_holder.global_position, food_string, popup_lifetime)

func end_day_behavior():
	pass
