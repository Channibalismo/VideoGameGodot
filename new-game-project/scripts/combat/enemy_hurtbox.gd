extends Area2D
## Forwards Patch-Driver hits to the parent enemy — same convention the
## training dummies use, so bullets don't need any enemy-specific code.

func take_hit(token: String) -> void:
	var parent := get_parent()
	if parent.has_method("take_hit"):
		parent.take_hit(token)
