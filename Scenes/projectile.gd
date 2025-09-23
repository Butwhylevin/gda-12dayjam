extends Area2D

@export var speed = 1
@export var damage = 1
@export var pierce = 1
@export var stun_time = 0.1
@export var lifetime = 0.3
@export var lead_time = 0.1

@onready var cur_pierce = pierce
var velocity
var estimated_travel_time
var actual_travel_time = 0

func _ready() -> void:
	cur_lifetime = lifetime

var cur_lifetime
func _physics_process(delta: float) -> void:
	cur_lifetime -= delta
	actual_travel_time += delta
	if (cur_lifetime <= 0):
		queue_free()
	
	velocity = speed * transform.x
	translate(velocity * delta)

func on_hit_enemy(_enemy_hit : Area2D):
	cur_pierce -= 1
	print("Estimated travel time: ", estimated_travel_time, " Actual Travel Time:", actual_travel_time)
	if cur_pierce <= 1:
		queue_free()
