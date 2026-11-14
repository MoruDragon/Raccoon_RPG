extends Resource
class_name SaveData

# Put other save states here
@export var talked_to_rat := false
@export var seen_opening := false
@export var current_map: String
@export var valve_puzzle_states: Dictionary = {
	"V1": false,
	"V2": false,
	"V3": false,
	"V4": false
}
