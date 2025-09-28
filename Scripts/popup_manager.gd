extends Node2D

@export var popup_scene : PackedScene
@export var popup_velocity : Vector2
@onready var ui_popup_holder = $"/root/GameManager/UI Manager"

func do_popup(pos : Vector2, text : String, lifetime : float):
	var popup = popup_scene.instantiate()
	popup.setup(lifetime, text, popup_velocity)
	self.add_child(popup)
	popup.set_global_position(pos + Vector2(-39.5, 0))

func do_ui_popup(pos : Vector2, text : String, lifetime : float):
	var popup = popup_scene.instantiate()
	popup.setup(lifetime, text, popup_velocity)
	ui_popup_holder.add_child(popup)
	popup.position = (pos + Vector2(-39.5, 0))
