extends Resource
class_name SaveData

# Put other save states here
@export var talked_to_rat := false
@export var current_position := Vector2(0,0)
@export var valve_puzzle_states: Dictionary = {}

func _create_save_state(player: CharacterBody2D) -> void:
	current_position = player.position
	valve_puzzle_states = ValvePuzzleManager.valve_states.duplicate()

func _load_save_state(player: CharacterBody2D) -> void:
	player.position = current_position
	if not valve_puzzle_states.is_empty():
		ValvePuzzleManager.valve_states = valve_puzzle_states.duplicate()
		ValvePuzzleManager.evaluate_puzzle()

func _create_default_save() -> void:
	current_position = Vector2(290.0,292.0)
	valve_puzzle_states = {
		"V1": false,
		"V2": false,
		"V3": false,
		"V4": false
	}
