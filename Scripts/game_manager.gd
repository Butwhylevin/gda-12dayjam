extends Node

var current_scene = null

@export var game_active = false
@export var start_health = 100
@export var start_money = 0
@export var wave_reward_money = 100
@export var start_food = 10
@export var start_pop = 3
@export var start_housing = 3
@export var fast_forwards_speed = 2
@export var win_wave_sound : AudioStream
@export var lose_life_sound : AudioStream
@export var start_scene : String
@export var win_scene : String

signal on_day_start
signal on_night_start

@onready var ui_manager = $"UI Manager"
@onready var popup_manager = $"Popup Manager"

var player_health : int
var money : int
var food : int
var pop : int
var open_pop : int
var housing : int

var is_fast_forwarding = false
var audio_player : AudioStreamPlayer2D

#region Base Functions
func _ready():
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)
	audio_player = AudioStreamPlayer2D.new()
	add_child(audio_player)
	
	reset()

func reset():
	money = start_money
	player_health = start_health
	food = start_food
	pop = start_pop
	open_pop = pop
	housing = start_housing
	game_active = false
	
	ui_manager.update_all()

func _input(event: InputEvent) -> void:
	if !game_active:
		return
	
	if event.is_action_pressed("toggle_fast_forwards"):
		toggle_fast_forwards()
	
	if event.is_action_pressed("start_wave") && is_day:
		start_night()

#endregion

#region Day / Night
var is_day : bool = true

func start_day():
	audio_player.stream = win_wave_sound
	audio_player.play()
	is_day = true
	ui_manager.update_time()
	money_changed(wave_reward_money)
	
	# grow the population to equal the food or housing (whichever is smaller)
	if housing > pop + 1 and food > pop + 1:
		var incr = min(housing - pop, food - pop)
		pop += incr
		open_pop += incr
		popup_manager.do_ui_popup(ui_manager.house_popup.position, "+" + str(incr) + " pop", 1)
	
	on_day_start.emit()

func start_night():
	# consume resources
	consume_resources_for_pop()
	ui_manager.update_all()
	
	# wait a sec, then start night
	await get_tree().create_timer(1.0).timeout
	
	is_day = false
	ui_manager.update_time()
	on_night_start.emit()
	

var daily_food : int = 0

func consume_resources_for_pop():
	# consume one food for each pop
	food -= pop
	
	# if food is negative, 1 person dies for each missing food
	if food < 0:
		pop += food
		open_pop += food
		food = 0
		popup_manager.do_ui_popup(ui_manager.house_popup.position, "Starvation!", 1)
		if pop <= 0:
			player_die()


#endregion

#region Public Functions
func player_take_damage(damage : int):
	player_health -= damage
	audio_player.stream = lose_life_sound
	audio_player.play()
	ui_manager.update_hp()
	if player_health <= 0:
		player_die()

func player_die():
	get_tree().change_scene_to_file(start_scene)

# Changing Player Values
func use_population(to_use : int):
	open_pop -= to_use
	ui_manager.update_resources()

func housing_changed(change : int):
	housing += change
	ui_manager.update_resources()

func money_changed(change : int):
	money += change
	ui_manager.update_money()

func win_game():
	get_tree().change_scene_to_file(win_scene)
	game_active = false

func food_changed(change : int):
	food += change
	ui_manager.update_resources()

func update_wave_ui(wave : int):
	ui_manager.update_wave(wave)

func toggle_fast_forwards():
	is_fast_forwarding = !is_fast_forwarding
	Engine.time_scale = 1 if !is_fast_forwarding else fast_forwards_speed

#endregion
