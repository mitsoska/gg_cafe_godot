extends Node2D

@onready var money_text = $MoneyText
@onready var xp_text = $XPText
@onready var servings_text = $ServingsText
@onready var ready_text = $ReadyText
@onready var food_text = $FoodText
@onready var type = $Type
@onready var ingredients = $Ingredients
@onready var food = $Food

@onready var cook_button = $ActionButton

func seconds_to_time_format(seconds) -> String:
	
	var minutes = floor(int(seconds) / 60);
	var hours = floor(int(minutes) / 60);
	
	minutes -= hours * 60;
	
	var output = " %02d:%02d:%02d" % [hours, minutes , int(seconds) - 60 * minutes - 3600 * hours];
	
	# If there are no hours present (00:01:00) then there is no reason to display them
	return output.replace(" 00:", "");
	
func reflect_state(food_index: int) -> void:
	# If we're out of range, just make this transparent
	if food_index > len(constants.food) - 1:
		visible = false
	else:
		visible = true
		food_text.text = constants.food[food_index]["name"];
		xp_text.text = str(constants.food[food_index]["xp"]);
		money_text.text = "%d per serving" % constants.food[food_index]["price"];
		ready_text.text = "Ready in: %s" % seconds_to_time_format(constants.food[food_index]["pre_time"]);
		servings_text.text = "Servings: %d" % constants.food[food_index]["servings"];
		
		type.frame = constants.food[food_index]["type"];
		food.animation = str(food_index);
		
		# Some items seem to have completely different frames
		food.frame = 3;
		
		for i in range(ingredients.get_child_count()):
			var current_child = ingredients.get_child(i);
			
			if (i < len(constants.food[food_index].ingredients)):
				current_child.modulate.a = 1.0;
				current_child.get_child(0).frame = constants.food[food_index].ingredients[i][0];
				current_child.get_child(1).text = "x %d" % constants.food[food_index].ingredients[i][1];
			else:
				# I don't just make it invisible, because that completely erases the child.4
				current_child.modulate.a = 0;

func _on_action_button_mouse_entered():
	# Scale the button from the center
	cook_button.pivot_offset = cook_button.size / 2;
	cook_button.scale = Vector2(1.3, 1.3);

func _on_action_button_mouse_exited():
	cook_button.scale = Vector2(1, 1);
