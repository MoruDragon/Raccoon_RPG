extends StaticBody2D

# The compiled .dialogue file resource to load for this NPC.
# Drag your .dialogue file into this slot in the Godot Inspector.
@export var dialogue_resource: DialogueResource
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var physics_collision: CollisionShape2D = $PhysicsCollision

# The starting title marker inside the .dialogue file (matches the '~ start' label).
@export var dialogue_cue: String = "start"

func flip_h(flip_dir: bool) -> void:
	sprite_2d.flip_h = flip_dir

func scale_collision(scale: float) -> void:
	var scale_vector := Vector2(scale, scale)
	physics_collision.scale = scale_vector
	
func collision_offset(x:int, y:int) -> void:
	physics_collision.position = Vector2(x,y)

# Called polymorphically by player.gd when the player is in range and presses the interact key.
func interact() -> void:
	# Verify that a dialogue resource has been assigned to prevent null reference errors.
	if dialogue_resource:
		# Spawns Dialogue Manager built-in GUI balloon to display lines and options.
		# This handles text layout, typing effects, and choice selections automatically.
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_cue)
