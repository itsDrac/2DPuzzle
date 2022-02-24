extends Control

@export var tile_scene: PackedScene
@export_range(3,8) var grid_size: int = 5

@onready var reset_timer: Timer = $Reset_time 

var img_size = 500/grid_size
var board = []
var original_frame = []
var current_frame = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var frame = 0
	for r in range(grid_size):
		for c in range(grid_size):
			var tile := tile_scene.instantiate()
			tile.set_position(Vector2(c * img_size, r * img_size))
			tile.set_sprite(frame, grid_size)
			add_child(tile)
			board.append(tile)
			frame += 1
			original_frame.append(frame)
		
	current_frame = original_frame.duplicate()
	await get_tree().create_timer(3).timeout
	current_frame.shuffle()
	shuffle_board(current_frame)
	reset_timer.start()


func shuffle_board(frames):
	var frame = 0
	for c in get_children():
		if c.is_in_group("tile"):
			c.set_sprite(frames[frame], grid_size)
			frame += 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print(event.position)
		print("A click!")

func _on_reset_time_timeout():
	current_frame.shuffle()
	shuffle_board(current_frame)
