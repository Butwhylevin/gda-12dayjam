extends Sprite2D

func _ready() -> void:
	GameManager.on_day_start.connect(day)
	GameManager.on_night_start.connect(night)

func day():
	visible = false

func night():
	visible = true
