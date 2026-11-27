extends Node2D

@export var background_music: AudioStream
@export var sewer_dialogue : DialogueResource = preload("res://dialogue/tunnel.dialogue")

func _ready() -> void:
	AudioManager.play_music(background_music)
	DialogueManager.show_dialogue_balloon(sewer_dialogue, "tunnelstart")

	
