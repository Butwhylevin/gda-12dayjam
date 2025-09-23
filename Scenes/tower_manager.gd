extends Node2D

var placing_tower = false
@export var tower_cost = 1
@export var tower_scene : PackedScene

@onready var build_tower_preview : Sprite2D = $"Build Preview"
@onready var build_tower_area : Area2D = $"Build Preview/Build Area"

func _ready() -> void:
	build_tower_preview.visible = placing_tower

var good_spot = false
func _process(_delta: float) -> void:
	# set the build pos to the mouse position in world space
	build_tower_preview.global_position = get_global_mouse_position()
	
	good_spot = can_place_tower_here()
	build_tower_preview.self_modulate = Color.RED if !good_spot else Color.WHITE

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_build_mode"):
		toggle_build_mode()
	elif event.is_action_pressed("interact"):
		try_place_tower()

func toggle_build_mode():
	print("toggle build mode")
	placing_tower = !placing_tower
	build_tower_preview.visible = placing_tower

func can_afford_tower() -> bool:
	return GameManager.money >= tower_cost

func can_place_tower_here() -> bool:
	var overlap = build_tower_area.get_overlapping_areas()
	return overlap.is_empty()

func try_place_tower():
	print("try place tower")
	if !placing_tower || !can_afford_tower() || !good_spot:
		return
	
	var tower = tower_scene.instantiate()
	GameManager.money_changed(-tower_cost)
	add_child(tower)
	tower.global_position = build_tower_preview.global_position
