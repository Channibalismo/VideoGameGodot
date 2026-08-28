extends Area2D

@export var speed: float = 480.0
@export var lifetime: float = 2.5

var direction := Vector2.RIGHT


func _ready() -> void:
	rotation = direction.angle()
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(lifetime).timeout
	if is_instance_valid(self):
		queue_free()


func _physics_process(delta: float) -> void:
	position += direction * speed * delta * CombatTime.scale


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("die"):
		body.die()
	queue_free()
