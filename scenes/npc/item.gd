@tool
extends Sprite2D

# The compiled .dialogue file resource to load for this NPC.
# Drag your .dialogue file into this slot in the Godot Inspector.
@export var dialogue_resource: DialogueResource

# The starting title marker inside the .dialogue file (matches the '~ start' label).
@export var dialogue_cue: String = "start"

@export var item_id: String = ""

# Called polymorphically by player.gd when the player is in range and presses the interact key.
func interact() -> void:
	# Verify that a dialogue resource has been assigned to prevent null reference errors.
	if dialogue_resource:
		# Spawns Dialogue Manager built-in GUI balloon to display lines and options.
		# This handles text layout, typing effects, and choice selections automatically.
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_cue)
		
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if GameState.save_data.get(item_id):
		visible = false

func _validate_property(property: Dictionary) -> void:
	if property.name == &"item_id":
		property.hint = PROPERTY_HINT_ENUM
		property.hint_string = ",".join(Util.get_save_data_variables())
