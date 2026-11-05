extends Node

# The path to the user's save data
const SAVE_DATA_PATH = "user://savedata.tres"
@export var save_data: SaveData

# Players registers itself when entering the tree.
var player: CharacterBody2D

func _ready():
	load_save()


func save_game() -> void:
	# Saves the save upon ctrl+s 
	print("Saving game")
	_create_save_state()
	ResourceSaver.save(save_data, SAVE_DATA_PATH)


func _create_save_state() -> void:
	# Loads the save state with the correct information
	save_data.valve_puzzle_states = ValvePuzzleManager.valve_states.duplicate()


func load_save() -> void:
	# Checks if the save exists, if it does then it loads it
	if not ResourceLoader.exists(SAVE_DATA_PATH):
		print("Making new save")
		save_data = SaveData.new()
		_create_default_save()
	else:
		print("Loading old save")
		save_data = ResourceLoader.load(SAVE_DATA_PATH)
	_load_save_state()


func _create_default_save() -> void:
	# Makes a default save state
	save_data.valve_puzzle_states = {
		"V1": false,
		"V2": false,
		"V3": false,
		"V4": false
	}


func _load_save_state() -> void:
	if not save_data.valve_puzzle_states.is_empty():
		ValvePuzzleManager.valve_states = save_data.valve_puzzle_states.duplicate()
		ValvePuzzleManager.evaluate_puzzle()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		save_game()
	if event.is_action_pressed("delete_save"):
		_delete_save()


func _delete_save() -> void:
	# Deletes the save upon ctrl+shift+alt+d
	print("Deleting save")
	if ResourceLoader.exists(SAVE_DATA_PATH):
		DirAccess.remove_absolute(SAVE_DATA_PATH)
	load_save()
