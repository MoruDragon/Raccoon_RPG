extends Area2D

@export var flavor_dialogue:  DialogueResource
@export var dialogue_start: String = "trash_can_interaction"

func interact() -> void:
	DialogueManager.show_dialogue_balloon(flavor_dialogue, dialogue_start)
	
