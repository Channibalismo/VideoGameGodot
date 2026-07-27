extends Control
## Root script for WorldMap.tscn — wires up XP/coin display, the player
## position marker, and navigation back to the main menu.

@onready var player_marker: Sprite2D = $PlayerMaker
@onready var xp_label: Label = $XPLabel
@onready var coins_label: Label = $CoinsLabel
@onready var back_button: Button = $BackButton
@onready var lesson_nodes: Node2D = $LessonNodes

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	GameState.xp_changed.connect(_on_xp_changed)
	GameState.coins_changed.connect(_on_coins_changed)
	GameState.lesson_completed.connect(_on_lesson_completed)

	_refresh_labels()
	_move_marker_to_current_lesson()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_xp_changed(_new_xp: int) -> void:
	_refresh_labels()

func _on_coins_changed(_new_coins: int) -> void:
	_refresh_labels()

func _on_lesson_completed(_lesson_number: int) -> void:
	_move_marker_to_current_lesson()

func _refresh_labels() -> void:
	xp_label.text = "⭐ XP: %d" % GameState.xp
	coins_label.text = "🪙 Coins: %d" % GameState.coins

## Places the player marker on the node for the next lesson to play.
func _move_marker_to_current_lesson() -> void:
	var current := GameState.get_current_lesson()
	var node_name := "Lesson%d" % current
	if lesson_nodes.has_node(node_name):
		var lesson_node: Node2D = lesson_nodes.get_node(node_name)
		player_marker.global_position = lesson_node.global_position + Vector2(0, -40)
