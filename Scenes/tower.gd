extends Node2D

## VARIABLES
# inspector attributes
@export var shoot_wait = 0.2
@export var bullet_scene : PackedScene

# references
@onready var tower_range : Area2D = $"Tower Range"
@onready var enemy_path : Path2D = $"/root/World/Enemy Controller/EnemyPath"
@onready var debug_circle : Node2D = $"Debug Point"

## BASE FUNCTIONS
func _process(delta: float) -> void:
	shooting_behavior(delta)

## OTHER FUNCTIONS
#region Shooting
var cur_shoot_wait = 0
func shooting_behavior(delta: float):
	if !enemy_in_range():
		cur_shoot_wait = 0
		return
	
	cur_shoot_wait += delta
	#print("Firing at enemy ", cur_shoot_wait)
	
	if (cur_shoot_wait >= shoot_wait):
		cur_shoot_wait = 0
		do_shoot()

# perform a shoot attack, creating a projectile aimed at an enemy
func do_shoot():
	# get the target enemy
	var target = get_target()
	
	# shoot at the target
	var bullet : Area2D = bullet_scene.instantiate()
	GameManager.add_child(bullet)
	bullet.global_position = global_position
	
	
	## lead your shots by sampling a further along point on the curve
	# get an initial estimate of the travel time
	var enemy_path_follow : PathFollow2D = target.get_parent()
	var travel_time = global_position.distance_to(target.global_position) / (bullet.speed)
	var future_enemy_point : Vector2 = target.global_position
	
	for i in range(5):
		# get the point on the enemy path that the enemy will be at at this time
		var future_progress = enemy_path_follow.progress + (enemy_path_follow.speed * travel_time)
		future_enemy_point = enemy_path.curve.sample_baked(future_progress, false)
		# just for debug purposes
		debug_circle.global_position = future_enemy_point
		# repeat these steps 5 times to get a good estimate
		travel_time = global_position.distance_to(future_enemy_point) / (bullet.speed)
	
	bullet.look_at(future_enemy_point)
	bullet.estimated_travel_time = travel_time
	

#endregion

#region Range / Targets
# Area2D array of all enemies in range, unsorted
var enemies_in_range : Array

# returns true if there are any enemies in the tower's range
func enemy_in_range() -> bool:
	return !enemies_in_range.is_empty()

# gets the target who is the furthest on the path
func get_target() -> Area2D:
	var furthest_dist = 0
	var target = enemies_in_range[0]
	
	var i = 1
	while i < enemies_in_range.size():
		var dist = enemies_in_range[i].get_parent().get_progress()
		if dist > furthest_dist:
			furthest_dist = dist
			target = enemies_in_range[i]
		i += 1
	
	return target

# keep track of all enemies in tower's range
# NOTE: this way is better than constantlly calling get_overlapping_bodies, both in performance and accuracy
func _on_tower_range_area_entered(area: Area2D) -> void:
	if (area.collision_layer == 2):
		enemies_in_range.append(area)

func _on_tower_range_area_exited(area: Area2D) -> void:
	if (area.collision_layer == 2):
		enemies_in_range.erase(area)

#endregion
