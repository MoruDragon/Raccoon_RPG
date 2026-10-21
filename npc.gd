extends Area2D

# The compiled .dialogue file resource to load for this NPC.
# Drag your .dialogue file into this slot in the Godot Inspector.
@export var dialogue_resource: DialogueResource

# The starting title marker inside the .dialogue file (matches the '~ start' label).
@export var dialogue_start_title: String = "start"

# Called polymorphically by player.gd when the player is in range and presses the interact key.
func interact() -> void:
	# Verify that a dialogue resource has been assigned to prevent null reference errors.
	if dialogue_resource:
		# Spawns the Nathan Hoad Dialogue Manager built-in GUI balloon to display lines and options.
		# This handles text layout, typing effects, and choice selections automatically.
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start_title)
