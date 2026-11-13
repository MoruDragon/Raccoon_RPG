extends Node

@export var opening_dialogue: DialogueResource = preload("uid://jwje6kjck28p")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not GameState.save_data.seen_opening:
		DialogueManager.show_dialogue_balloon(
			opening_dialogue, 
			"start",
			[get_parent()])
