extends Node2D

@export var background_music: AudioStream

func _ready() -> void:
	AudioManager.play_music(background_music)
