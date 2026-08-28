extends Sprite2D

const SIZE := 22.0
const FILL := Color(0.2, 0.6, 1.0, 1.0)
const OUTLINE := Color(0.05, 0.05, 0.1, 1.0)


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	var r := Rect2(-SIZE / 2.0, -SIZE / 2.0, SIZE, SIZE)
	draw_rect(r, FILL)
	draw_rect(r, OUTLINE, false, 2.0)
