extends Control

var timer_on = false
var time = 0

@onready var watch = $watch
@onready var menu = $menu
@onready var difficulty: OptionButton = $difficultybtn

# Called when the node enters the scene tree for the first time.
func _ready():
	difficulty.add_item("Normal",1)
	difficulty.add_item("Hard",2)
	difficulty.add_item("Won",3)
	difficulty.selected = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_on:
		time += delta
	
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60) / 60
	
	var time_passed = "Time > %2d : %2d" % [mins, secs]
	watch.set_text(time_passed)

