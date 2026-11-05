extends StaticBody2D

@export var valve_id: String = "V1"

var current_status: String:
	get:
		if ValvePuzzleManager.is_valve_open(valve_id):
			return "OPEN"
		return "CLOSED"


func toggle() -> void:
	ValvePuzzleManager.toggle_valve(valve_id)
