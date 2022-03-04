extends TextureButton

var number

signal primary_tile
signal secondary_tile
signal slide_completed

@onready var sprite: Sprite2D= $Sprite2D
@onready var border: Panel = $Border

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if sprite.get_rect().has_point(sprite.to_local(event.position)):
			if event.button_index == MOUSE_BUTTON_LEFT:
				emit_signal("primary_tile", self)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				emit_signal("secondary_tile", self)
		

func change_border_color(color = Color.WHITE):
	var sbox: StyleBoxFlat = border.get_theme_stylebox("panel").duplicate()
	sbox.border_color = color
	border.add_theme_stylebox_override("panel",sbox)

# Update the number of the tile
func set_text(new_number):
	number = new_number
	$Number/Label.text = str(number)

# Update the background image of the tile
func set_sprite(new_frame, size):
	var sprite = $Sprite2D

#	update_size(size, tile_size)

	sprite.set_hframes(size)
	sprite.set_vframes(size)
	sprite.set_frame(new_frame)

# scale to the new tile_size
func update_size(size, tile_size):
	var new_size = Vector2(tile_size, tile_size)
	set_size(new_size)
	$Number.set_size(new_size)
	$Number/ColorRect.set_size(new_size)
	$Number/Label.set_size(new_size)
	$Panel.set_size(new_size)

	var to_scale = size * (new_size / $Sprite.texture.get_size())
	$Sprite.set_scale(to_scale)

# Update the entire background image
func set_sprite_texture(texture):
	$Sprite.set_texture(texture)

# Slide the tile to a new position
func slide_to(new_position, duration):
	var tween = get_tree().create_tween()
	tween.interpolate_property(self, "rect_position", null, new_position, duration, Tween.TRANS_QUART, Tween.EASE_OUT)
	tween.start()

# Hide / Show the number of the tile
func set_number_visible(state):
	$Number.visible = state

# Tile has finished sliding
func _on_Tween_tween_completed(_object, _key):
	emit_signal("slide_completed", number)
