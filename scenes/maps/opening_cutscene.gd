extends Node2D

@export var starting_animations: Array[String]
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	for anim in starting_animations:
		animation_player.play(anim)

func pause_to_play_cutscene_anim(animation_name: String) -> void:
	animation_player.play(animation_name)
	await animation_player.animation_finished

func play_cutscene_anim(animation_name: String) -> void:
	animation_player.play(animation_name)

func wait_for_cutscene_anim(animation_name: String) -> void:
	if animation_player.is_playing() and animation_player.current_animation == animation_name:
		await animation_player.animation_finished
