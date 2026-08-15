extends Control
## Root script for WorldMap.tscn — a Mario-style walkable overworld.
## A/D walks the character between lesson nodes along the path (only onto
## unlocked ones); Enter/Space plays whichever node you're standing on.
## Clicking a node directly still works too (instant fast-travel, handled
## by lesson_node.gd) and also snaps the walking marker there.

## Lesson1..Lesson9, in the same left-to-right order as the drawn path.
const PATH_ORDER := [1, 2, 3, 4, 5, 6, 7, 8, 9]
const WALK_DURATION := 0.22
const CAMERA_FOLLOW_SPEED := 6.0

@onready var player_marker: Node2D = $PlayerMarker
@onready var xp_label: Label = $UI/XPLabel
@onready var coins_label: Label = $UI/CoinsLabel
@onready var back_button: Button = $UI/BackButton
@onready var lesson_nodes: Node2D = $LessonNodes
@onready var camera: Camera2D = $Camera2D
@onready var hint_label: Label = $UI/HintLabel

var current_path_index: int = 0
var is_walking: bool = false


func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	GameState.xp_changed.connect(_on_xp_changed)
	GameState.coins_changed.connect(_on_coins_changed)
	GameState.lesson_completed.connect(_on_lesson_completed)

	_refresh_labels()
	_snap_marker_to_current_lesson()


func _unhandled_input(event: InputEvent) -> void:
	if is_walking:
		return
	if event.is_action_pressed("move_right"):
		_try_step(1)
	elif event.is_action_pressed("move_left"):
		_try_step(-1)
	elif event.is_action_pressed("ui_accept"):
		_try_enter_current_lesson()


func _process(delta: float) -> void:
	camera.global_position = camera.global_position.lerp(
		player_marker.global_position, clamp(CAMERA_FOLLOW_SPEED * delta, 0.0, 1.0)
	)


func _try_step(direction: int) -> void:
	var target_index := current_path_index + direction
	if target_index < 0 or target_index >= PATH_ORDER.size():
		return
	var target_lesson: int = PATH_ORDER[target_index]
	if not GameState.is_unlocked(target_lesson):
		_play_blocked_feedback()
		return
	_walk_to_index(target_index)


func _walk_to_index(index: int) -> void:
	current_path_index = index
	var node := _current_node()
	is_walking = true
	var tw := create_tween()
	tw.tween_property(player_marker, "global_position", node.global_position + Vector2(0, -40), WALK_DURATION)
	tw.finished.connect(func(): is_walking = false)


func _current_node() -> Node2D:
	return lesson_nodes.get_node("Lesson%d" % PATH_ORDER[current_path_index])


func _try_enter_current_lesson() -> void:
	var lesson_number: int = PATH_ORDER[current_path_index]
	if not GameState.is_unlocked(lesson_number):
		return
	var path := "res://scenes/Lesson%d.tscn" % lesson_number
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		push_warning("WorldMap: no scene found at %s" % path)


func _play_blocked_feedback() -> void:
	var tw := create_tween()
	var start_pos := player_marker.position
	tw.tween_property(player_marker, "position", start_pos + Vector2(6, 0), 0.05)
	tw.tween_property(player_marker, "position", start_pos - Vector2(6, 0), 0.05)
	tw.tween_property(player_marker, "position", start_pos, 0.05)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _on_xp_changed(_new_xp: int) -> void:
	_refresh_labels()


func _on_coins_changed(_new_coins: int) -> void:
	_refresh_labels()


func _on_lesson_completed(_lesson_number: int) -> void:
	_snap_marker_to_current_lesson()


func _refresh_labels() -> void:
	xp_label.text = "⭐ XP: %d" % GameState.xp
	coins_label.text = "🪙 Coins: %d" % GameState.coins


## Places the player marker on the node for the next lesson to play,
## instantly (no walk animation) — used on scene entry and after completion.
func _snap_marker_to_current_lesson() -> void:
	var current := GameState.get_current_lesson()
	var index := PATH_ORDER.find(current)
	if index == -1:
		index = 0
	current_path_index = index
	var node := _current_node()
	player_marker.global_position = node.global_position + Vector2(0, -40)
	camera.global_position = player_marker.global_position
