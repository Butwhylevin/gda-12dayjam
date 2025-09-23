extends Control

@onready var hp_label = $"HP Label"
@onready var money_label = $"Money Label"

func update_hp():
	hp_label.set_text("HP: " + str(GameManager.player_health))

func update_money():
	money_label.set_text("$" + str(GameManager.money))
