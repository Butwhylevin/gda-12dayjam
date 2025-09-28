extends Node2D

var placing_tower = true
@export var towers : Array[TowerResource]
var tower_index = 0

@onready var build_tower_preview : Sprite2D = $"Build Preview"
@onready var build_tower_area : Area2D = $"Build Preview/Build Area"
@onready var build_tower_name : Label = $"Build Preview/Label"

func _ready() -> void:
	build_tower_preview.visible = placing_tower
	GameManager.ui_manager.update_tower(towers[tower_index])
	GameManager.ui_manager.set_tower_visible(placing_tower)

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
	elif event.is_action_pressed("increase_selected_tower"):
		change_selected_tower(1)
	elif event.is_action_pressed("decrease_selected_tower"):
		change_selected_tower(-1)

func change_selected_tower(change : int):
	if !placing_tower:
		return
	
	tower_index += change
	if tower_index < 0:
		tower_index = towers.size()-1
	elif tower_index >= towers.size():
		tower_index = 0
	
	# update ui
	GameManager.ui_manager.update_tower(towers[tower_index])
	
	# update preview
	build_tower_preview.texture = towers[tower_index].sprite
	build_tower_name.text = towers[tower_index].name
	
	#build_tower_preview.

func toggle_build_mode():
	print("toggle build mode")
	placing_tower = !placing_tower
	build_tower_preview.visible = placing_tower
	GameManager.ui_manager.set_tower_visible(placing_tower)

func can_afford_tower() -> bool:
	var tower_res = towers[tower_index]
	return GameManager.money >= tower_res.cost and GameManager.food >= tower_res.food_cost and GameManager.open_pop >= tower_res.pop_cost

func can_place_tower_here() -> bool:
	var overlap = build_tower_area.get_overlapping_areas()
	return overlap.is_empty()

func try_place_tower():
	print("try place tower")
	if !placing_tower || !can_afford_tower() || !good_spot:
		return
		
	var tower_res = towers[tower_index]
	var tower = tower_res.scene.instantiate()
	
	GameManager.money_changed(-tower_res.cost)
	GameManager.food_changed(-tower_res.food_cost)
	GameManager.use_population(tower_res.pop_cost)
	GameManager.housing_changed(tower_res.housing_gain)
	
	add_child(tower)
	tower.global_position = build_tower_preview.global_position
