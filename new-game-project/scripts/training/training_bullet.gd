extends Area2D
## Patch-Driver energy round. Carries whatever token was loaded via the
## Compiler Readout HUD when it was fired.

@export var speed: float = 1600.0
@export var lifetime: float = 2.5

var direction := Vector2.RIGHT
var token: String = ""


func _ready() -> void:
	rotation = direction.angle()
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(lifetime).timeout
	if is_instance_valid(self):
		queue_free()


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_hit"):
		area.take_hit(token)
	queue_free()


func _on_body_entered(_body: Node) -> void:
	queue_free()
