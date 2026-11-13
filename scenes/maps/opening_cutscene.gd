extends Node2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Fight")

func pause_to_play_cutscene_animation(animation_name: String) -> void:
	animation_player.play(animation_name)
	await animation_player.animation_finished

func play_cutscene_animation(animation_name: String) -> void:
	animation_player.play(animation_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
