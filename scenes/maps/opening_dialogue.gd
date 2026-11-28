extends Node

@export var opening_dialogue: DialogueResource = preload("uid://jwje6kjck28p")
@export var wire1_dialogue : DialogueResource = preload("res://dialogue/wire1.dialogue")
## Variable in save_data for whether this dialogue has played already
@export var seen_variable: StringName = "seen_opening"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameState.save_data.get("seen_wire"):
		DialogueManager.show_dialogue_balloon(
			wire1_dialogue,
			"wire_start",
			[get_parent()]
		)
	
	elif not GameState.save_data.get(seen_variable):
		DialogueManager.show_dialogue_balloon(
			opening_dialogue, 
			"start",
			[get_parent()])
