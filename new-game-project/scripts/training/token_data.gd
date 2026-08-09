class_name TokenData
extends RefCounted
## Shared lookup table for Patch-Driver round types.
## Add new rounds here later (=, [], //, break;) — everything else
## (HUD, targets) reads from this single source.

const TOKENS := {
	";": {
		"name": "Semicolon Shot",
		"java": "int hp = 10;\n// The ; marks the end of a statement.",
		"effect": "Fixes missing-terminator glitches."
	},
	"!": {
		"name": "NOT / Invert Bullet",
		"java": "boolean isHostile = true;\nisHostile = !isHostile; // -> false",
		"effect": "Inverts the target's hostile flag."
	},
}


static func get_info(token: String) -> Dictionary:
	return TOKENS.get(token, {})


static func is_valid(token: String) -> bool:
	return TOKENS.has(token)
