extends Control

@export var tile_scene: PackedScene
@export var grid_size: int = 5

@onready var reset_timer: Timer = $Reset_time
@onready var base: Control = $base  

var ed = preload("res://src/scenes/base/ed.tscn")
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
	base.difficulty.item_selected.connect(difficulty_change)
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
	if base.difficulty.selected == 2:
#		var e = ed.instantiate()
#		add_child(e)
#		move_child(e,0)
		print("you have selected ED")
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

func change_clickable():
	for c in board:
		if c.is_in_group("tile"):
			c.disabled = not c.disabled

func game_pause():
	base.timer_on = not base.timer_on
	reset_timer.paused = not reset_timer.paused

func difficulty_change(i: int):
	base.difficulty.selected = i
	print(i)
	if i == 0:
		reset_timer.wait_time = 500 
	
	elif i == 1:
		reset_timer.wait_time = 200
	
	elif i == 2:
		var e = ed.instantiate()
#		e.mouse_filter = Control.MOUSE_FILTER_IGNORE
		mouse_filter = Control.MOUSE_FILTER_STOP
		add_child(e)
		change_clickable()
#		move_child(e,0)
	reset_timer.stop()
	shuffle_board(frames)
	reset_timer.start()
