extends Node
## Global combat time-dilation factor. 1.0 = normal. Enemies (and anything
## else that wants to respect Sandevistan) multiply their own movement by
## this value. The player deliberately ignores it, so only the world
## around them appears to slow down.

var scale: float = 1.0
