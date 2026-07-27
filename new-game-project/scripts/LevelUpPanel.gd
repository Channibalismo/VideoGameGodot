extends Control

@onready var label = $Label
@onready var animation_player = $AnimationPlayer

func _ready():
	visible = false

func show_level(level: int):
	label.text = "LEVEL UP!\nLevel " + str(level)
	visible = true
	animation_player.play("level_up")
