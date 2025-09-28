extends Node2D

var is_night = false
var not_touching_track : bool
@export var trap_scene : PackedScene
@export var trap_wait : float = 0.5
@export var tower_radius : float

@onready var enemy_path : Path2D = $"/root/World/Enemy Controller/EnemyPath"

func _ready() -> void:
	GameManager.on_day_start.connect(end_night_behavior)
	GameManager.on_night_start.connect(start_night_behavior)
	cur_trap_wait = 0
	
	if !GameManager.is_day:
		start_night_behavior()
	
	check_if_touching_track()

func check_if_touching_track():
	# check if radius overlaps with enemy track at all
	not_touching_track = false

func start_night_behavior():
	is_night = true
	cur_trap_wait = 0

func end_night_behavior():
	is_night = false

func _process(delta: float) -> void:
	if is_night && !not_touching_track:
		do_night(delta)

var cur_trap_wait : float = 0
func do_night(delta : float):
	cur_trap_wait -= delta
	if cur_trap_wait <= 0:
		cur_trap_wait = trap_wait
		spawn_trap()

func _random_inside_unit_circle() -> Vector2:
	var theta : float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf())

func get_random_point_on_path_within_radius(max_attempts: int = 1000) -> Vector2:
	if enemy_path == null or enemy_path.curve == null:
		push_error("No path or curve assigned.")
		return global_position

	var curve := enemy_path.curve
	var length := curve.get_baked_length()

	for attempt in max_attempts:
		var t := randf() * length
		var point := (enemy_path.curve.sample_baked(t))
		if point.distance_to(global_position) <= tower_radius:
			return point - global_position
	
	print("failed to find a point in 1000 attempts")
	not_touching_track = true
	return global_position

func spawn_trap():
	var point = get_random_point_on_path_within_radius()
	var trap = trap_scene.instantiate()
	trap.global_position = point
	add_child(trap)
