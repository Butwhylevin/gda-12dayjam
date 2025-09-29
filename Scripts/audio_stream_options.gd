extends AudioStreamPlayer2D

@export var audioPitchRange = Vector2(0.9, 1.1)

func _ready() -> void:
	pitch_scale = randf_range(audioPitchRange.x, audioPitchRange.y)
