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
	"=0": {
		"name": "Assignment Bullet",
		"java": "int robotHealth = 10;\nrobotHealth = 0; // = overwrites the value",
		"effect": "Overwrites target health to zero — instant shutdown."
	},
	"[]": {
		"name": "Array Shotgun",
		"java": "Bullet[] magazine = new Bullet[3];\n// [] declares a collection of values",
		"effect": "Fires a multi-pellet spread for crowd control."
	},
	"//": {
		"name": "Comment Shield",
		"java": "// This whole line is ignored by the compiler.",
		"effect": "Deploys a barrier — incoming shots are \"commented out\"."
	},
	"break;": {
		"name": "Break Slug",
		"java": "while (attacking) {\n\tbreak; // exits the loop immediately\n}",
		"effect": "Heavy stun — cancels an enemy's attack loop."
	},
	"null": {
		"name": "Null Pointer Round",
		"java": "Object charge = null; // clears the reference",
		"effect": "Alternate disarm round — nulls out a live charge before it detonates."
	},
	"(Player)": {
		"name": "Type-Cast Bullet",
		"java": "(Player) target = (Player) enemy; // re-casts the reference type",
		"effect": "Re-casts a hostile unit's target type — makes it treat you as an ally."
	},
	"String[]": {
		"name": "String Array Piercer",
		"java": "String[] freqList = new String[3];\n// [] on a String declares an array of them",
		"effect": "Piercing beam — cuts through cover and signal jamming."
	},
}


static func get_info(token: String) -> Dictionary:
	return TOKENS.get(token, {})


static func is_valid(token: String) -> bool:
	return TOKENS.has(token)
