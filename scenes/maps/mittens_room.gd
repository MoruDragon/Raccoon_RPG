extends Node2D
@onready var xiu: StaticBody2D = $Npcs/Xiu
@onready var mittens: StaticBody2D = $Npcs/Mittens
@onready var npc_pigeon: StaticBody2D = $"Npcs/Npc Pigeon"
@onready var xius_dad: StaticBody2D = $"Npcs/Xius Dad"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mittens.scale_collision(4)
	mittens.collision_offset(0,-29)
	xiu.flip_h(true)
	npc_pigeon.flip_h(true)
	xius_dad.flip_h(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
