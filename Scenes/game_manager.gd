extends Node

var player_health : int = 100
var current_scene = null
var is_fast_forwarding = false
@export var fast_forwards_speed = 2

@onready var ui_manager = $"UI Manager"

func _ready():
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)

func player_take_damage(damage : int):
	player_health -= damage
	ui_manager.update_hp()
	print("Player took damage, hp: ", player_health)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fast_forwards"):
		toggle_fast_forwards()

func toggle_fast_forwards():
	print("TOGGLE FAST FORWARDS")
	is_fast_forwarding = !is_fast_forwarding
	Engine.time_scale = 1 if !is_fast_forwarding else fast_forwards_speed
