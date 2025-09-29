extends PathFollow2D

@export var sprite_offset : Vector2
@export var sprites : Array[Texture]
@export var speed : float
@export var hp : int = 1
@export var money_reward : int = 1
@export var hurt_sound : AudioStream

@export var death_part_scene : PackedScene
var spawner

var default_anim = "enemy_anim"
@onready var area : Area2D = $Area2D
@onready var sprite : Sprite2D = $"Sprite Holder/Sprite2D"
@onready var anim : AnimationPlayer = $"Sprite Holder/AnimationPlayer"
@onready var sprite_holder : Node2D = $"Sprite Holder"


func _ready() -> void:
	sprite.texture = sprites.pick_random()
	sprite_holder.position = Vector2(randf_range(sprite_offset.x, sprite_offset.y),randf_range(sprite_offset.x, sprite_offset.y))
	anim.current_animation = default_anim
	anim.speed_scale = randf_range(0.2, 1)

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
	AudioManager.play(hurt_sound)
	
	if (hp <= 0):
		die(true)
		return false
	
	sprite.set_instance_shader_parameter("flash_value", 1)
	end_flash()
	
	return true

func end_flash():
	await get_tree().create_timer(0.2).timeout
	sprite.set_instance_shader_parameter("flash_value", 0)

var has_died = false
func die(was_killed : bool):
	if has_died:
		return
		
	has_died = true
	if was_killed: 
		# do death particles
		var death_part : GPUParticles2D = death_part_scene.instantiate()
		spawner.add_child(death_part)
		death_part.emitting = true
		death_part.global_position = global_position
		death_part.finished.connect(death_part.queue_free)
		
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
