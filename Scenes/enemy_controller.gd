extends Node

# PLACEHOLDER SPAWNING: just endlessly spawn enemies
@export var spawn_wait = 0.5
var enemy_scene = preload("res://Scenes/enemy.tscn")

@onready var enemy_path = $EnemyPath

var cur_spawn_wait = 0
func _process(delta: float) -> void:
	cur_spawn_wait += delta
	if (cur_spawn_wait >= spawn_wait):
		cur_spawn_wait = 0
		spawn_enemy(enemy_scene)

func spawn_enemy(to_spawn : PackedScene):
	var enemy = to_spawn.instantiate()
	enemy_path.add_child(enemy)
