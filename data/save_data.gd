extends Resource
class_name SaveData

# Put other save states here
@export var talked_to_rat := bool(true)
@export var current_position := Vector2(0,0)

func _create_save_state(player: CharacterBody2D) -> void:
	current_position = player.position

func _load_save_state(player: CharacterBody2D) -> void:
	player.position = current_position
