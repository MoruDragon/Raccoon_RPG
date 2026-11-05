extends Node

signal puzzle_state_updated(is_drained: bool)

var valve_states: Dictionary = {
	"V1": false,
	"V2": false,
	"V3": false,
	"V4": false
}

const ADJACENCY: Dictionary = {
	"Input": ["V2", "V3"],
	"V1": ["Drain"],
	"V2": ["Leak"],
	"V3": ["V1", "V2", "V4"],
	"V4": ["Drain", "Leak"],
	"Drain": [],
	"Leak": []
}

func toggle_valve(valve_id: String) -> bool:
	if valve_states.has(valve_id):
		valve_states[valve_id] = not valve_states[valve_id]
		evaluate_puzzle()
		return valve_states[valve_id]
	return false

func is_valve_open(valve_id: String) -> bool:
	return valve_states.get(valve_id, false)

func is_puzzle_solved() -> bool:
	var reached: Array[String] = ["Input"]
	var queue: Array[String] = ["Input"]
	
	while queue.size() > 0:
		var current: String = queue.pop_front()
		
		if valve_states.has(current) and not valve_states[current]:
			continue
			
		for neighbor in ADJACENCY.get(current, []):
			if not reached.has(neighbor):
				reached.append(neighbor)
				queue.append(neighbor)
	
	var drain_reached: bool = reached.has("Drain")
	var leak_reached: bool = reached.has("Leak")
	return drain_reached and not leak_reached

func evaluate_puzzle() -> void:
	puzzle_state_updated.emit(is_puzzle_solved())
