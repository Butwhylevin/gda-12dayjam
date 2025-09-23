extends Node

var current_scene = null

@export var start_health = 100
@export var start_money = 0
@export var fast_forwards_speed = 2

@onready var ui_manager = $"UI Manager"

var player_health : int
var money : int

var is_fast_forwarding = false

func _ready():
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)
	ui_manager.update_money()
	
	reset()

func reset():
	money = start_money
	player_health = start_health
	ui_manager.update_hp()
	ui_manager.update_money()

func player_take_damage(damage : int):
	player_health -= damage
	ui_manager.update_hp()
	if player_health <= 0:
		get_tree().reload_current_scene()

func money_changed(change : int):
	money += change
	ui_manager.update_money()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fast_forwards"):
		toggle_fast_forwards()

func toggle_fast_forwards():
	print("TOGGLE FAST FORWARDS")
	is_fast_forwarding = !is_fast_forwarding
	Engine.time_scale = 1 if !is_fast_forwarding else fast_forwards_speed
