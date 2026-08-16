class_name TokenData
extends RefCounted
## Shared lookup table for Patch-Driver round types — the 7 core Java
## override patches used to cure/decommission glitched robots.
## Everything else (HUD, targets, codex) reads from this single source.

const TOKENS := {
	";": {
		"name": "Semicolon Patch",
		"java": "System.out.println(\"Cure\");",
		"effect": "Basic syntax fix. Completes interrupted statements and instantly cures light glitched units (HouseBots)."
	},
	"!": {
		"name": "NOT / Invert Patch",
		"java": "isHostile = !isHostile;",
		"effect": "Logic inversion. Reverses target state/alignment (turns hostile ShieldBots into friendly barriers, disarms ExplodingBots)."
	},
	"=0": {
		"name": "Assignment Overwrite",
		"java": "targetHP = 0;",
		"effect": "Variable overwrite. Directly sets internal enemy attributes to zero for instant decommissioning (ArmedBots, CourierBot timers)."
	},
	"break;": {
		"name": "Break Slug",
		"java": "while(attacking) { break; }",
		"effect": "Loop termination. Immediately exits hostile execution loops, interrupting and stunning charging enemies (CombatBots)."
	},
	"//": {
		"name": "Comment Shield",
		"java": "// player.takeDamage(50);",
		"effect": "Statement bypass. Deploys a barrier that comments out incoming projectile damage so collision detection ignores it."
	},
	"(Player)": {
		"name": "Class Type-Cast",
		"java": "TargetType target = (Player) currentUnit;",
		"effect": "Reference reassignment. Overrides targeting classes (forces MedBots to heal the player instead of enemy units)."
	},
	".setPower(false);": {
		"name": "Terminal Shutdown",
		"java": "system.setPower(false);",
		"effect": "Multi-line terminal override. Disables heavy industrial hazards (CraneBots) directly via console ports."
	},
}


static func get_info(token: String) -> Dictionary:
	return TOKENS.get(token, {})


static func is_valid(token: String) -> bool:
	return TOKENS.has(token)
