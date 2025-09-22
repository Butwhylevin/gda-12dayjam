extends PathFollow2D

@export var speed : float
@export var hp : int = 1

var cur_stun_time = 0
func _process(delta: float) -> void:
	if (cur_stun_time > 0):
		cur_stun_time -= delta
		return
	
	# move along the path at a constant speed
	progress += delta * speed
	
	# if path is completed, die and deal damage
	if (progress_ratio == 1.0):
		GameManager.player_take_damage(1)
		queue_free()

func do_stun(stun_time : float):
	if (stun_time == 0):
		return
	
	cur_stun_time = stun_time

# returns true if still alive
func take_damage(damage : int) -> bool:
	hp -= damage
	if (hp <= 0):
		queue_free()
		return false
	
	return true

func _on_area_2d_area_entered(bullet: Area2D) -> void:
	if bullet.collision_layer != 2:
		return
	
	bullet.on_hit_enemy(self)
	if !take_damage(bullet.damage):
		return
	
	do_stun(bullet.stun_time)
