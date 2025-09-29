extends Node2D

@export var game_scene : String

func _on_button_pressed() -> void:
	
	get_tree().change_scene_to_file(game_scene)
	GameManager.game_active = true
