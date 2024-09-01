extends Node2D

@onready var floor_tilemap = $World/FloorTilemap
@onready var furniture_container = $World/Furniture
@onready var tile_overlay = $World/FloorTilemap/TileOverlay
@onready var player = $World/Furniture/Player
@onready var recipe_book = $Interface/RecipeBook

const cursor_arrow = preload("res://assets/interface/pointer_normal.png")
const cursor_pointing = preload("res://assets/interface/pointer_hover.png")
const cursor_grab = preload("res://assets/interface/pointer_grab1.png")
const cursor_grab2 = preload("res://assets/interface/pointer_grab2.png")

var is_frozen := false
# The current tile that the mouse is over
# Leave to an invalid value to indicate that it's currently outside the map
var current_tile: Vector2i

# Furniture will be handled using scene instances
var oven = preload("res://scenes/oven.tscn")

var map_width := 7
var map_height := 7

# The tile towards which the player will move, once he chooses which recipe to make
var next_tile;

# TODO: Make this load the game from a saved file,
# instead of just defining it globally and statically
var furniture = [
	[null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null],
	[oven.instantiate(), null, null, null, null, null, null],
]

	
func is_tile_valid(tile: Vector2i) -> bool:
	return tile.x >= 0 and tile.x < map_width and \
			tile.y >= 0 and tile.y < map_height
			
func is_tile_occupied(tile: Vector2i) -> bool:
	return furniture[tile.y][tile.x] != null
	
func is_humanoid_next_to_furniture(humanoid, tile: Vector2i) -> bool:
	var difference = humanoid.tile_pos - tile
	return abs(difference.x) + abs(difference.y) == 1
	
func find_humanoid_facing_direction(end: Vector2i, furniture: Vector2i) -> constants.Direction:
	var difference: Vector2i = end - furniture
	
	if difference.x == 0:
		return constants.Direction.DOWN if difference.y == -1 else constants.Direction.UP
	
	if difference.y == 0:
		return constants.Direction.RIGHT if difference.x == -1 else constants.Direction.LEFT
		
	# This means that the humanoid is not next to the furniture
	return constants.Direction.INVALID
	
func manhattan_distance(first: Vector2i, second: Vector2i) -> int:
	return abs(first.x + first.y - (second.x + second.y))
	
func find_tile_next_to_furniture(humanoid, tile: Vector2i) -> Vector2i:
	var valid_tiles = []
	
	for i in range(-1, 2):
		for j in range(-1, 2):
			if abs(i) + abs(j) != 1: continue
			var new_tile = Vector2i(tile.x + i, tile.y + j)
			
			if is_tile_valid(new_tile) and !is_tile_occupied(new_tile):
				valid_tiles.push_back(new_tile)
	
	# If the tiles are not actually near each other, return an invalid value
	# The user should ideally use is_humanoid_next_to_furniture() instead
	if len(valid_tiles) == 0:
		return Vector2i(-1, -1)
		
	# If tiles do exist, find the one closest to the player
	var min_index = 0
	var min_distance = manhattan_distance(valid_tiles[0], humanoid.tile_pos)
	
	for i in range(len(valid_tiles)):
		var new_distance = manhattan_distance(valid_tiles[i], humanoid.tile_pos)
		if new_distance < min_distance:
			min_distance = new_distance
			min_index = i 
			
	return valid_tiles[min_index]

func find_path_from_to(start_x, start_y, end_x, end_y) -> Array[constants.Direction]:
	var bfs_predecessor = []
	var directions: Array[constants.Direction] = []
	
	# Creating the BFS queue and initializing some values
	var queue = []
	queue.push_back(Vector2i(start_x, start_y))
	
	# The bfs_predecessors should be a 2D array with a size
	# identical to that of our map representation
	for i in range(map_height):
		var column = []
		
		for j in range(map_width):
			column.append(null)
			
		bfs_predecessor.push_back(column)
		
	var bfs_insert_neighbour = func bfs_insert_neighbour (tile: Vector2i, dir) -> void:
		if bfs_predecessor[tile.y][tile.x] == null and !is_tile_occupied(tile):
			queue.push_back(tile)
			bfs_predecessor[tile.y][tile.x] = dir
			
	while len(queue) != 0:
		var cur = queue.pop_front()
		
		# If we've reached the end, reconstruct the path
		if cur.x == end_x and cur.y == end_y:
			var reco = cur
			
			while reco.x != start_x or reco.y != start_y:
				var dir = bfs_predecessor[reco.y][reco.x]
				directions.push_front(dir)
				
				match dir:
					constants.Direction.RIGHT: reco.x -= 1
					constants.Direction.LEFT: reco.x += 1
					constants.Direction.UP: reco.y += 1
					constants.Direction.DOWN: reco.y -= 1
					
			return directions
		
		if (cur.x != 0): bfs_insert_neighbour.call(Vector2i(cur.x - 1, cur.y), constants.Direction.LEFT)
		if (cur.y != 0): bfs_insert_neighbour.call(Vector2i(cur.x, cur.y - 1), constants.Direction.UP)
		if (cur.x != map_width - 1): bfs_insert_neighbour.call(Vector2i(cur.x + 1, cur.y), constants.Direction.RIGHT)
		if (cur.y != map_height - 1): bfs_insert_neighbour.call(Vector2i(cur.x, cur.y + 1), constants.Direction.DOWN)
	# If no path was found, just return null
	return []
	
func move_humanoid(humanoid, tile_pos: Vector2i, final_dir := constants.Direction.INVALID) -> void:
	if !is_tile_valid(tile_pos): return
	# If we're already there, don't bother
	if humanoid.tile_pos == tile_pos: return
	if is_tile_occupied(tile_pos): return
	
	var directions = find_path_from_to(humanoid.tile_pos.x, humanoid.tile_pos.y, tile_pos.x, tile_pos.y)
	var tween = create_tween()
	
	for direction in directions:
		match direction:
			constants.Direction.LEFT: humanoid.tile_pos.x -= 1
			constants.Direction.RIGHT: humanoid.tile_pos.x += 1
			constants.Direction.UP: humanoid.tile_pos.y -= 1
			constants.Direction.DOWN: humanoid.tile_pos.y += 1
		
		var new_position = floor_tilemap.to_global(
			floor_tilemap.map_to_local(humanoid.tile_pos)
		)
		
		# Tween the humanoid based on the current direction
		# Make sure to play an animation as well
		tween.chain().tween_callback(humanoid.play_animation.bind(direction))
		tween.chain().tween_property(humanoid, "global_position", new_position, constants.HUMAN_ANIMATION_SPEED)
			
	tween.play()
	
	if final_dir != constants.Direction.INVALID:
		await tween.finished
		humanoid.face_to(final_dir)
	
func set_furniture_position(entity, tile_position: Vector2i) -> void:
	entity.tile_pos = tile_position
	entity.global_position = floor_tilemap.to_global(
		floor_tilemap.map_to_local(tile_position)
	)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# Making the cursor work.
	# TODO: Implement the grabbing animation
	Input.set_custom_mouse_cursor(cursor_arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(cursor_pointing, Input.CURSOR_POINTING_HAND)

	for i in map_height:
		for j in map_width:
			var entity = furniture[i][j]
			
			# Position the furniture on the tilemap, if it exists
			if furniture[i][j] != null:
				entity.tile_pos = Vector2i(j, i)
				furniture_container.add_child(entity)
				set_furniture_position(entity, entity.tile_pos)
				entity.input_event.connect(on_oven_mouse.bind(entity))
			
	set_furniture_position(player, Vector2i(2, 0))
	
func on_oven_mouse(_viewport, event: InputEvent, _shape_idx, oven) -> void:
	# If it's a click event, process the state
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# If we're not near the oven, move to it
					
		if !is_humanoid_next_to_furniture(player, oven.tile_pos):
			var next_tile = find_tile_next_to_furniture(player, oven.tile_pos)
			#move_humanoid(player, tile, find_humanoid_facing_direction(tile, oven.tile_pos))
			recipe_book.visible = true;
	
func _input(event):
	if is_frozen: return
	
	if event is InputEventMouseMotion:
		# Check if we're currently hovering over a tile
		var tile: Vector2i = floor_tilemap.local_to_map(floor_tilemap.to_local(event.position))

		# If the tile has not been moved, don't bother
		if (tile.x == current_tile.x and tile.y == current_tile.y): return
		
		# Highlight that tile with a darker overlay
		# Do not highlight it if there's a piece of furniture on top of it
		if (is_tile_valid(tile) and furniture[tile.y][tile.x] == null):
			current_tile = Vector2i(tile.x, tile.y)
			tile_overlay.visible = true
			tile_overlay.position = floor_tilemap.map_to_local(tile)
		else:
			current_tile = Vector2i(-1, -1)
			tile_overlay.visible = false
			
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# If we've clicked on a valid tile and aren't frozen, move there
		move_humanoid(player, current_tile)

func handle_cooking(i):
	print(i);
