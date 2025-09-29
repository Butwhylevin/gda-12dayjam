extends Area2D

@export var speed = 1
@export var damage = 1
@export var pierce = 1
@export var stun_time = 0.1
@export var lifetime = 0.3

@onready var cur_pierce = pierce
var velocity

func _ready() -> void:
	cur_lifetime = lifetime
	GameManager.on_day_start.connect(die)

var cur_lifetime
func _physics_process(delta: float) -> void:
	cur_lifetime -= delta
	if (cur_lifetime <= 0):
		queue_free()
	
	velocity = speed * transform.x
	translate(velocity * delta)

func die():
	queue_free()

func on_hit_enemy(_enemy_hit : Area2D):
	cur_pierce -= 1
	if cur_pierce <= 1:
		queue_free()
