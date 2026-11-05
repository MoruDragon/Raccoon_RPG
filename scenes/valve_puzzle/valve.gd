extends StaticBody2D

@export var valve_id: String = "V1"
@export var dialogue_resource: DialogueResource = preload("uid://iwh1a71h1lri")
@export var dialogue_start_title: String = "start"

var current_status: String:
	get:
		if ValvePuzzleManager.is_valve_open(valve_id):
			return "OPEN"
		return "CLOSED"


func toggle() -> void:
	ValvePuzzleManager.toggle_valve(valve_id)

func interact() -> bool:
	if dialogue_resource:
		DialogueManager.show_dialogue_balloon(
			dialogue_resource, dialogue_start_title, [self]
		)
		return true
	return false
