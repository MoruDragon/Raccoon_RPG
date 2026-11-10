extends Node

@export var opening_dialogue: DialogueResource = preload("uid://jwje6kjck28p")
@export_file("*.tscn") var dialogue_balloon: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	if !GameState.save_data.seen_opening:
		DialogueManager.show_dialogue_balloon_scene(dialogue_balloon, opening_dialogue, "start")
