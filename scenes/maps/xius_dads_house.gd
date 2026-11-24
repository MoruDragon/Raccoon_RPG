extends Node2D

@export var background_music: AudioStream
@export var xiudad_dialogue : DialogueResource = preload("res://dialogue/xiudadscene.dialogue")

func _ready() -> void:
	AudioManager.play_music(background_music)
	DialogueManager.show_dialogue_balloon(xiudad_dialogue, "xiudadstart")
	
