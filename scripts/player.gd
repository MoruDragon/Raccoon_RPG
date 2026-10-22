extends CharacterBody2D

# Movement speed in pixels per second.
# @export exposes the variable directly to the Godot Inspector dock.
@export var move_speed: float = 140.0

# Reference to the child AnimatedSprite2D node handling visual animation playback.
# @onready delays assignment until this node and its children enter the scene tree.
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Reference to the child Area2D node that scans for interactable targets.
@onready var interaction_detector: Area2D = $InteractionDetector

# State flag to freeze player movement, inputs, and state changes during dialogue.
var is_talking: bool = false

func _ready() -> void:
	# Connect to the global signal provided by the Dialogue Manager autoload singleton.
	# DialogueManager emits 'dialogue_ended' when a conversation balloon closes.
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	# Set the initial visual state to the idle animation loop on scene load.
	sprite.play("idle")

func _physics_process(_delta: float) -> void:
	# Halt all kinematic processing and force the idle pose when dialogue is active.
	if is_talking:
		velocity = Vector2.ZERO
		move_and_slide()
		sprite.play("idle")
		return

	# Input.get_vector reads 4 directional inputs, applies deadzones, and normalizes
	# the resulting vector to a maximum length of 1.0 to ensure uniform speed on diagonals.
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Scale the directional vector by movement speed to compute per-second displacement velocity.
	velocity = input_direction * move_speed
	
	# move_and_slide moves the character body along the velocity vector and handles collisions.
	move_and_slide()

	# Update the animation state and horizontal orientation based on input direction.
	_update_animation(input_direction)

func _update_animation(direction: Vector2) -> void:
	# A zero vector indicates no directional input; set the character to idle.
	if direction == Vector2.ZERO:
		sprite.play("idle")
	else:
		sprite.play("walk")

		# Flip sprite horizontally on the X-axis to face the travel direction.
		if direction.x < 0.0:
			sprite.flip_h = true
		elif direction.x > 0.0:
			sprite.flip_h = false

func _unhandled_input(event: InputEvent) -> void:
	# Discard interaction input if a dialogue sequence is active.
	if is_talking:
		return

	# _unhandled_input fires only when GUI elements have not consumed the input event.
	if event.is_action_pressed("interact"):
		# Retrieve all Area2D shapes currently inside the interaction trigger zone.
		var overlapping_areas: Array[Area2D] = interaction_detector.get_overlapping_areas()
		
		for area in overlapping_areas:
			# Duck typing: verify the target area contains an 'interact' method before invoking.
			# This decouples the Player node from hard dependencies on specific NPC classes.
			if area.has_method("interact"):
				is_talking = true
				area.interact()
				# Terminate search after triggering the first valid interactable target in range.
				break

# Callback executed when DialogueManager signals that conversation has concluded.
func _on_dialogue_ended(_resource: Resource) -> void:
	# Restore player movement, inputs, and interaction capability.
	is_talking = false
