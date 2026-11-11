extends StaticBody2D

# The compiled .dialogue file resource to load for this NPC.
# Drag your .dialogue file into this slot in the Godot Inspector.
@export var dialogue_resource: DialogueResource

# The starting title marker inside the .dialogue file (matches the '~ start' label).
@export var dialogue_start_title: String = "start"

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called polymorphically by player.gd when the player is in range and presses the interact key.
func interact() -> void:
	# Verify that a dialogue resource has been assigned to prevent null reference errors.
	if dialogue_resource:
		# Spawns Dialogue Manager built-in GUI balloon to display lines and options.
		# This handles text layout, typing effects, and choice selections automatically.
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start_title, [self])

func jump() -> void:
	animation_player.play("jump")
	await animation_player.animation_finished
