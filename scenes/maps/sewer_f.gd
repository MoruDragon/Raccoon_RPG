extends Node2D

@export var background_music: AudioStream
@export var sewer_dialogue1 : DialogueResource = preload("res://dialogue/tunnel1.dialogue")

func _ready() -> void:
	AudioManager.play_music(background_music)
	DialogueManager.show_dialogue_balloon(sewer_dialogue1, "tunnelstart")
