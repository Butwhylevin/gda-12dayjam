extends PathFollow2D

@export var speed : float
@export var hp : int = 1
@export var money_reward : int = 1
var spawner

@onready var area : Area2D = $Area2D

var cur_stun_time = 0
func _physics_process(delta: float) -> void:
	if (cur_stun_time > 0):
		cur_stun_time -= delta
		return
	
	# move along the path at a constant speed
	progress += delta * speed
	
	# if path is completed, die and deal damage
	if (progress_ratio == 1.0):
		GameManager.player_take_damage(1)
		die(false)

func do_stun(stun_time : float):
	if (stun_time == 0):
		return
	
	cur_stun_time = stun_time

# returns true if still alive
func take_damage(damage : int) -> bool:
	hp -= damage
	if (hp <= 0):
		die(true)
		return false
	
	return true

var has_died = false
func die(was_killed : bool):
	if has_died:
		return
		
	has_died = true
	if was_killed: 
		GameManager.money_changed(money_reward)
	
	spawner.kill_enemy()
	queue_free()

func _on_area_2d_area_entered(bullet: Area2D) -> void:
	print("area entered")
	
	if bullet.get_collision_layer_value(4):
		return
	
	print("is bullet")
	bullet.on_hit_enemy(area)
	if !take_damage(bullet.damage):
		return
	
	do_stun(bullet.stun_time)
