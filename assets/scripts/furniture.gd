extends Node2D

@onready var food = $Food

# A piece of furniture will need its tile position
# for the game to function properly. 
var tile_pos: Vector2i
var has_entered = false;

enum State {
	CLEAN,
	PREPARING,
	COOKING,
	DIRTY,
}

var food_index: int
# How many ingredients have already been processed
var ready_ingredients: int = 0
var state: State = State.PREPARING
var is_in_queue = false

func set_is_in_queue(new_value: bool) -> void:
	is_in_queue = new_value
	modulate = 0x33333344 if is_in_queue else 0xffffffff

func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	has_entered = true;

func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	has_entered = false;
