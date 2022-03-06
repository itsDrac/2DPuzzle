extends Control

@export var tile_scene: PackedScene
@export var grid_size: int = 5

@onready var reset_timer: Timer = $Reset_time
@onready var base: Control = $base  


var img_size = 500/grid_size
var frames = range(grid_size * grid_size)
var board = []
var selected_tile = null
signal solved

# Called when the node enters the scene tree for the first time.
func _ready():
	var frame = 0
	for r in range(grid_size):
		for c in range(grid_size):
			var tile := tile_scene.instantiate()
			tile.set_position(Vector2(c * img_size, r * img_size))
			tile.set_sprite(frame, grid_size)
			tile.connect("primary_tile", primary_tile)
			tile.connect("secondary_tile", secondary_tile)
			add_child(tile)
			board.append(tile)
			frame += 1
			
		
	await get_tree().create_timer(3).timeout
	base.menu.pressed.connect(game_pause)
	base.timer_on = true
	frames.shuffle()
	print(frames)
	shuffle_board(frames)
	reset_timer.start()
	

func shuffle_board(frames):
	var frame = 0
	for c in get_children():
		if c.is_in_group("tile"):
			c.set_sprite(frames[frame], grid_size)
			frame += 1

func check_win():
	var f = []
	for c in get_children():
		if c.is_in_group("tile"):
			f.append(c.sprite.frame)
	
	print(f)
	print(f == range(grid_size * grid_size))
	emit_signal("solved")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_reset_time_timeout():
	frames.shuffle()
	shuffle_board(frames)

func primary_tile(tile: TextureButton):
	selected_tile.change_border_color(Color.WHITE) if selected_tile else null
	tile.change_border_color(Color.BROWN)
	selected_tile = tile

func secondary_tile(tile: TextureButton):
	if selected_tile :
		if abs(board.find(selected_tile) - board.find(tile)) == 5 or abs(board.find(selected_tile) - board.find(tile)) == 1:
			var temp
			temp = selected_tile.sprite.frame
			selected_tile.sprite.frame = tile.sprite.frame
			tile.sprite.frame = temp
			check_win()
		selected_tile.change_border_color(Color.WHITE)
	selected_tile = null



func game_pause():
	print("pause from board")
	base.timer_on = false
	reset_timer.paused = not reset_timer.paused
