extends Node

# The path to the user's save data
const SAVE_DATA_PATH = "user://savedata.tres"
@export var save_resource: SaveData
var player_node:CharacterBody2D

func _ready():
	await get_tree().root.ready
	player_node = get_player()
	_load_save()
	
func get_player() -> CharacterBody2D:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		return players[0] as CharacterBody2D
	#print("Returning null")
	return null
	
func _save_game() -> void:
	# Saves the save upon ctrl+s 
	print("Saving game")
	_create_save_state(player_node)
	ResourceSaver.save(save_resource, SAVE_DATA_PATH)
	
func _create_save_state(player: CharacterBody2D) -> void:
	# Loads the save state with the correct information
	if not player:
		#print("No player detected")
		return
	save_resource.current_position = player.position

func _set_talked_to_rat() -> void:
	save_resource.talked_to_rat = true

func _load_save() -> void:
	# Checks if the save exists, if it does then it loads it
	if not ResourceLoader.exists(SAVE_DATA_PATH):
		print("Making new save")
		save_resource = SaveData.new()
		_create_default_save()
	else:
		print("Loading old save")
		save_resource = ResourceLoader.load(SAVE_DATA_PATH)
	_load_save_state(player_node)
	
func _create_default_save() -> void:
	# Makes a default save state
	save_resource.current_position = Vector2(290.0,292.0)
	
func _load_save_state(player: CharacterBody2D) -> void:
	# Puts in the saved data into the player
	if not player:
		return
	player.position = save_resource.current_position

	
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("save_game"):
		_save_game()
	if event.is_action_pressed("delete_save"):
		_delete_save()
		

func _delete_save() -> void:
	# Deletes the save upon ctrl+shift+alt+d
	print("Deleting save")
	if ResourceLoader.exists(SAVE_DATA_PATH):
		DirAccess.remove_absolute(SAVE_DATA_PATH)
