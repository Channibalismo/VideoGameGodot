extends Area2D
## Attach to each lesson node (Lesson1..Lesson9) in WorldMap.tscn.

@export var lesson_number: int = 1
@export var lesson_scene: String = "" ## e.g. "res://scenes/Lesson1.tscn". Falls back to a guessed path if empty.

@onready var label: Label = $Label

const RADIUS := 24.0
const COLOR_LOCKED := Color(0.5, 0.5, 0.55)
const COLOR_UNLOCKED := Color(1.0, 0.82, 0.25)
const COLOR_COMPLETED := Color(0.4, 0.85, 0.45)

var _fill_color := COLOR_LOCKED

func _ready() -> void:
	input_event.connect(_on_input_event)
	refresh_visual()
	GameState.lesson_completed.connect(func(_n): refresh_visual())

func refresh_visual() -> void:
	if GameState.is_completed(lesson_number):
		_fill_color = COLOR_COMPLETED
		label.text = "✔ %d" % lesson_number
	elif GameState.is_unlocked(lesson_number):
		_fill_color = COLOR_UNLOCKED
		label.text = "● %d" % lesson_number
	else:
		_fill_color = COLOR_LOCKED
		label.text = "🔒 %d" % lesson_number
	input_pickable = true
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, RADIUS, _fill_color)
	draw_arc(Vector2.ZERO, RADIUS, 0, TAU, 32, Color(0.15, 0.1, 0.05), 3.0)

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_try_open()

func _try_open() -> void:
	if not GameState.is_unlocked(lesson_number):
		_play_locked_feedback()
		return
	var path := lesson_scene
	if path == "":
		path = "res://scenes/Lesson%d.tscn" % lesson_number
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		push_warning("LessonNode: no scene found at %s" % path)

func _play_locked_feedback() -> void:
	var tw := create_tween()
	var start_pos := position
	tw.tween_property(self, "position", start_pos + Vector2(6, 0), 0.05)
	tw.tween_property(self, "position", start_pos - Vector2(6, 0), 0.05)
	tw.tween_property(self, "position", start_pos, 0.05)
