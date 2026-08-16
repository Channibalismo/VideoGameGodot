class_name BotCodexData
extends RefCounted
## Reference table for the Bot Codex popup. Mirrors the required_tokens
## each RogueBot subclass hardcodes in its own _bot_ready() — keep this
## in sync if a bot's accepted patch changes. Tokens come from the 7
## core Java override patches defined in TokenData.

const ENTRIES := [
	{
		"name": "HouseBot",
		"color": Color(0.75, 0.55, 0.25),
		"tokens": ";",
		"note": "Swarm/melee. Semicolon Patch instantly cures this lightly glitched unit."
	},
	{
		"name": "ArmedBot",
		"color": Color(0.35, 0.45, 0.85),
		"tokens": "=0",
		"note": "Cover shooter. Assignment Overwrite sets targetHP to zero."
	},
	{
		"name": "CombatBot",
		"color": Color(0.9, 0.2, 0.25),
		"tokens": "break;",
		"note": "Aggressive brawler. Break Slug terminates its attack loop."
	},
	{
		"name": "ExplodingBot",
		"color": Color(1.0, 0.55, 0.1),
		"tokens": "!",
		"note": "Suicide runner. NOT/Invert Patch flips isHostile before the fuse ends."
	},
	{
		"name": "ShieldBot",
		"color": Color(0.25, 0.7, 0.85),
		"tokens": "!",
		"note": "Frontal energy plate. NOT/Invert Patch turns it into a friendly barrier."
	},
	{
		"name": "MedBot",
		"color": Color(0.4, 0.9, 0.55),
		"tokens": "(Player)",
		"note": "Backline healer. Class Type-Cast forces it to heal you instead."
	},
	{
		"name": "SignalBot",
		"color": Color(0.85, 0.35, 0.95),
		"tokens": "=0",
		"note": "HUD jammer. Assignment Overwrite zeroes its jamming frequency."
	},
	{
		"name": "CourierBot",
		"color": Color(0.95, 0.85, 0.2),
		"tokens": "=0",
		"note": "Alarm sentry. Assignment Overwrite silences its timer before it transmits."
	},
	{
		"name": "CraneBot",
		"color": Color(0.55, 0.55, 0.6),
		"tokens": ".setPower(false);",
		"note": "Stage hazard. Immune to bullets; disable it at a nearby OmniKernel terminal with the Terminal Shutdown patch."
	},
	{
		"name": "MimicBot",
		"color": Color(0.45, 0.75, 0.95),
		"tokens": "any patch, once revealed",
		"note": "Ambush trap disguised as a survivor. Aim in close to reveal it, then any of the 7 patches works."
	},
]
