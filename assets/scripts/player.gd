extends Node2D

var tile_pos: Vector2i

var direction_data = [
	# The original game had created duplicate frames with flipped textures
	# We won't do this here, we can just change the transform matrix
	["walking_back", 1],
	["walking_front", -1],
	["walking_back", -1],
	["walking_front", 1]
]

func play_animation(direction: constants.Direction) -> void:
	scale.x = direction_data[direction][1]
	
	# Now, play the appropriate animation for each limb
	for child in get_children() as Array[AnimatedSprite2D]:
		# If the animation does not exist, just make it invisible
		var animation = direction_data[direction][0]
		
		if child.sprite_frames.has_animation(animation):
			child.visible = true
			child.stop()
			child.play(animation)
		else:
			child.visible = false

# Pretty much the same functionas before, but instead of playing the animation
# we just have to reset it to the very first frame
func face_to(direction: constants.Direction) -> void:
	scale.x = direction_data[direction][1]
		
	for child in get_children() as Array[AnimatedSprite2D]:
		var animation = direction_data[direction][0]
		
		if child.sprite_frames.has_animation(animation):
			# Don't play the animation, just face there
			child.visible = true
			child.animation = animation
			child.stop()
		else:
			child.visible = false
