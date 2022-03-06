extends Control

var timer_on = true
var time = 0

@onready var watch = $watch
@onready var menu = $menu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_on:
		time += delta
	
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60) / 60
	
	var time_passed = "Time > %2d : %2d" % [mins, secs]
	watch.set_text(time_passed)



func _on_menu_pressed():
	timer_on = not timer_on
	print("menu button clicked")
