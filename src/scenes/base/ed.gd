extends Control

@onready var label: Label = $ColorRect/Label
@onready var btn = $ColorRect/Button

var text = ["You solved the puzzle"]

func _ready():

	text.shuffle()
	label.text = text[0]
	print("text added")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	queue_free()
