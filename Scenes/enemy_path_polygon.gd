extends CollisionPolygon2D

@onready var path_2d : Path2D = $EnemyPath
@export var path_width = 1
var upper_border : PackedVector2Array
var lower_border : PackedVector2Array

func _ready():
	# Bake the curve into points and assign to the Polygon2D
	var points = path_2d.get_curve().get_baked_points()

	for i in range(points.size()):
		# find direction at this point
		var dir : Vector2
		if i == 0:
			dir = (points[i + 1] - points[i]).normalized()
		elif i == points.size() - 1:
			dir = (points[i] - points[i - 1]).normalized()
		else:
			var dir1 = (points[i] - points[i - 1]).normalized()
			var dir2 = (points[i + 1] - points[i]).normalized()
			dir = (dir1 + dir2).normalized()
		# perpendicular (normal)
		var normal = Vector2(-dir.y, dir.x) * (path_width / 2.0)
		var upper_point = points[i] + normal
		var lower_point = points[i] - normal
		
		upper_border.append(upper_point)
		upper_border.append(lower_point)
	
	lower_border.reverse()
	print(upper_border)
	upper_border.append_array(lower_border)
	polygon = upper_border
