extends Node

var current_scene = null

@export var start_health = 100
@export var start_money = 0
@export var start_food = 10
@export var start_pop = 3
@export var start_housing = 3
@export var fast_forwards_speed = 2

signal on_day_start
signal on_night_start

@onready var ui_manager = $"UI Manager"

var player_health : int
var money : int
var food : int
var pop : int
var open_pop : int
var housing : int

var is_fast_forwarding = false

#region Base Functions
func _ready():
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)
	
	reset()

func reset():
	money = start_money
	player_health = start_health
	food = start_food
	pop = start_pop
	open_pop = pop
	housing = start_housing
	
	ui_manager.update_all()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fast_forwards"):
		toggle_fast_forwards()
	
	if event.is_action_pressed("start_wave") && is_day:
		start_night()

#endregion

#region Day / Night
var is_day : bool = true

func start_day():
	is_day = true
	ui_manager.update_time()
	on_day_start.emit()

func start_night():
	# consume resources
	consume_resources_for_pop()
	
	# wait a sec, then start night
	await get_tree().create_timer(1.0).timeout
	
	is_day = false
	ui_manager.update_time()
	on_night_start.emit()
	

func consume_resources_for_pop():
	# consume one food for each pop
	food -= pop
	# TODO: grow pop by 1 if there is open housing
	
	# if food is negative, 1 person dies for each -1 food
	if food < 0:
		pop += food
		food = 0
	
	if pop <= 0:
		player_die()


#endregion

#region Public Functions
func player_take_damage(damage : int):
	player_health -= damage
	ui_manager.update_hp()
	if player_health <= 0:
		player_die()

func player_die():
	get_tree().reload_current_scene()

func money_changed(change : int):
	money += change
	ui_manager.update_money()

func food_changed(change : int):
	food += change
	ui_manager.update_resources()

func update_wave_ui(wave : int):
	ui_manager.update_wave(wave)

func toggle_fast_forwards():
	is_fast_forwarding = !is_fast_forwarding
	Engine.time_scale = 1 if !is_fast_forwarding else fast_forwards_speed

#endregion
