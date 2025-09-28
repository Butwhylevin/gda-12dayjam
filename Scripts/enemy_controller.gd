extends Node

# PLACEHOLDER SPAWNING: just endlessly spawn enemies
@export var spawn_wait = 0.5
@export var enemy_waves : Array[EnemyWave]

@onready var enemy_path = $EnemyPath

var can_start_new_wave : bool = true
var game_complete : bool = false

var cur_wave = -1
var cur_group = 0
var cur_enemy = 0
var cur_count = 0
var cur_spawn_wait = 0

func _ready() -> void:
	cur_wave = -1
	cur_group = 0
	cur_enemy = 0
	cur_count = 0
	cur_spawn_wait = 0
	
	GameManager.on_night_start.connect(start_new_wave)

func _process(delta: float) -> void:
	if can_start_new_wave:
		return
	
	cur_spawn_wait -= delta
	
	var wave = enemy_waves[cur_wave]
	var group = wave.groups[cur_group]
	var enemy = group.enemy_list[cur_enemy]
	
	# uh, idk if this is good but it works
	if cur_spawn_wait <= 0:
		spawn_enemy(enemy)
		cur_spawn_wait += group.delay_between_enemies
		cur_count += 1
		if cur_count >= group.enemy_count_list[cur_enemy]:
			cur_count = 0
			cur_enemy += 1
			if cur_enemy >= group.enemy_list.size():
				cur_enemy = 0
				cur_spawn_wait += group.delay_after_group
				cur_group += 1
				if cur_group >= wave.groups.size():
					cur_group = 0
					end_wave()

func end_wave():
	print("End Wave!")
	GameManager.start_day()
	can_start_new_wave = true

func start_new_wave():
	if game_complete:
		return
	
	cur_wave += 1
	
	if cur_wave >= enemy_waves.size():
		print("game done lol")
		game_complete = true
		return
	
	can_start_new_wave = false
	
	print("Start Wave!")
	GameManager.update_wave_ui(cur_wave+1)

func spawn_enemy(to_spawn : PackedScene):
	var enemy = to_spawn.instantiate()
	enemy_path.add_child(enemy)
