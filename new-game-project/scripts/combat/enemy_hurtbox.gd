extends Area2D

func take_hit(token: String) -> void:
	var parent := get_parent()
	if parent.has_method("take_hit"):
		parent.take_hit(token)
