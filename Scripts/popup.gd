extends Label

var lifetime = 1
var move_vel = Vector2.UP

var cur_lifetime = 0

func setup(m_lifetime : float, m_text : String, m_move_vel : Vector2):
	text = m_text
	lifetime = m_lifetime
	move_vel = m_move_vel

func _process(delta: float) -> void:
	# move up
	set_global_position(global_position + (move_vel * delta))
	# count down
	cur_lifetime += delta
	if cur_lifetime >= lifetime:
		queue_free()

func set_color(c : Color):
	add_theme_color_override("font_color", c)
