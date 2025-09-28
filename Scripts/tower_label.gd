extends RichTextLabel

@export var font_ref : Font
var pop_icon = " [img={30}]Sprites/pop-icon.png[/img]"
var house_icon = " [img={30}]Sprites/house-icon.png[/img]"
var food_icon = " [img={30}]Sprites/food-icon.png[/img]"

func update_tower_label(tower : TowerResource):
	var name_cost_str = tower.name + ": $" + str(tower.cost) + ", "
	var need_comma = false
	if tower.pop_cost > 0:
		name_cost_str += "-" + str(tower.pop_cost) + pop_icon
		need_comma = true
	
	if tower.food_cost > 0: 
		if need_comma:
			name_cost_str += ", "
		name_cost_str += "-" + str(tower.food_cost) + food_icon
		need_comma = true
	
	if tower.housing_gain > 0:
		if need_comma:
			name_cost_str += ", "
		name_cost_str += "+" + str(tower.housing_gain) + house_icon
		
	
	text = "[color=BLACK][font=res://Fonts/ITCKRIST.TTF][font_size=25]" + name_cost_str + "[/font_size]\n" + tower.desc
 
