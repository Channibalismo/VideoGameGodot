class_name BotCodexData
extends RefCounted
## Reference table for the Bot Codex popup. Mirrors the required_tokens
## each RogueBot subclass hardcodes in its own _bot_ready() — keep this
## in sync if a bot's accepted tokens change.

const ENTRIES := [
	{
		"name": "HouseBot",
		"color": Color(0.75, 0.55, 0.25),
		"tokens": "; or []",
		"note": "Swarm/melee. Weak — dies to a Semicolon Shot or the Array Shotgun."
	},
	{
		"name": "ArmedBot",
		"color": Color(0.35, 0.45, 0.85),
		"tokens": "=0",
		"note": "Cover shooter. Assignment Bullet overwrites robotHealth to zero."
	},
	{
		"name": "CombatBot",
		"color": Color(0.9, 0.2, 0.25),
		"tokens": "break;",
		"note": "Aggressive brawler. Break Slug interrupts its attack loop."
	},
	{
		"name": "ExplodingBot",
		"color": Color(1.0, 0.55, 0.1),
		"tokens": "! or null",
		"note": "Suicide runner. Invert (or null) flips isExploding to false before the fuse ends."
	},
	{
		"name": "ShieldBot",
		"color": Color(0.25, 0.7, 0.85),
		"tokens": "!",
		"note": "Frontal energy plate. Invert flips isFriendly — it turns and shields you instead."
	},
	{
		"name": "MedBot",
		"color": Color(0.4, 0.9, 0.55),
		"tokens": "(Player)",
		"note": "Backline healer. Type-cast its target to (Player) to make it heal you."
	},
	{
		"name": "SignalBot",
		"color": Color(0.85, 0.35, 0.95),
		"tokens": "String[]",
		"note": "HUD jammer. High priority — pierce it with the String[] beam."
	},
	{
		"name": "CourierBot",
		"color": Color(0.95, 0.85, 0.2),
		"tokens": "=0 or break;",
		"note": "Alarm sentry. Silence its timer before it finishes counting down."
	},
	{
		"name": "CraneBot",
		"color": Color(0.55, 0.55, 0.6),
		"tokens": "N/A — terminal only",
		"note": "Stage hazard. Immune to bullets; must be disabled at a nearby OmniKernel terminal."
	},
	{
		"name": "MimicBot",
		"color": Color(0.45, 0.75, 0.95),
		"tokens": "any token, once revealed",
		"note": "Ambush trap disguised as a survivor. Aim in close to reveal it, then any round works."
	},
]
