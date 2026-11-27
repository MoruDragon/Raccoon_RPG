extends Area2D

@export var dialogue_resource: DialogueResource = preload("uid://b0hjagsnchmao")
@export var dialogue_cue: String = "trash_can_interaction"

func interact() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_cue)
