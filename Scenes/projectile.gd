extends Area2D

@export var speed = 1
@export var damage = 1
@export var pierce = 1
@export var stun_time = 0.1

@onready var cur_pierce = pierce
var velocity

func _ready() -> void:
	print("bullet created")

func _physics_process(delta: float) -> void:
	velocity = speed * transform.x
	translate(velocity * delta)

func on_hit_enemy(_enemy_hit : Area2D):
	cur_pierce -= 1
	#if cur_pierce <= 1:
		#queue_free()
