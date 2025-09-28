extends Control

@export var sun_icon : Texture
@export var moon_icon : Texture

@onready var hp_label = $"HP Label"
@onready var money_label = $"Money Label"

@onready var wave_label = $"Wave Label"
@onready var time_texture : TextureRect = $"Time Icon"

@onready var pop_label = $"Population Label"
@onready var food_label = $"Food Label"
@onready var house_label = $"Housing Label"

func update_all():
	update_hp()
	update_money()
	update_resources()
	update_time()

func update_hp():
	hp_label.set_text(str(GameManager.player_health))

func update_money():
	money_label.set_text(str(GameManager.money))

func update_wave(wave : int):
	wave_label.set_text(str(wave))

func update_time():
	time_texture.texture = sun_icon if GameManager.is_day else moon_icon

func update_resources():
	pop_label.set_text(str(GameManager.open_pop) + "/" + str(GameManager.pop))
	food_label.set_text(str(GameManager.food))
	house_label.set_text(str(GameManager.housing))
