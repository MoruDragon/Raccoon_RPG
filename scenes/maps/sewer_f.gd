extends Node2D

@export var background_music: AudioStream
@export var tunnel_dialogue: DialogueResource = preload("res://dialogue/tunnel.dialogue")


func _ready() -> void:
	AudioManager.play_music(background_music)
	call_deferred("check_dialogue_process")
	
func check_dialogue_process():
	if GameState.save_data.seen_opening && GameState.save_data.seen_xiu_dad:
		DialogueManager.show_dialogue_balloon(tunnel_dialogue, "after_xiu_dad")
