extends Control

@onready var hp_label = $"HP Label"

func update_hp():
	hp_label.set_text("HP: " + str(GameManager.player_health))
