extends Control

@onready var items = $Items

var page_index := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	reflect_state()
	
	for i in range(items.get_child_count()):
		# Bind helps us pass variables to functions
		items.get_child(i).get_node("ActionButton").button_down.connect(on_button_click.bind(i))

func reflect_state() -> void:
	# Make the right or left arrow invisible if we've reached the end in either direction
	# Make it visible otherwise
	for i in range(items.get_child_count()):
		items.get_child(i).reflect_state(page_index * 4 + i)

func on_button_click(i: int) -> void:
	pass;

func _on_texture_button_pressed():
	page_index += 1;
	reflect_state();


func _on_texture_button_2_pressed():
	if (page_index != 0):
		print(page_index);
		page_index -= 1;
		reflect_state();
