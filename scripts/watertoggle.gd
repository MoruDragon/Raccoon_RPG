extends StaticBody2D

@onready var water_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	water_sprite.play()
	ValvePuzzleManager.puzzle_state_updated.connect(_on_puzzle_state_updated)
	
	# Immediately sync visual and collision states on scene load
	_on_puzzle_state_updated(ValvePuzzleManager.is_puzzle_solved())

func _on_puzzle_state_updated(is_drained: bool) -> void:
	visible = not is_drained
	collision_shape.set_deferred("disabled", is_drained)
	set_collision_layer_value(1, not is_drained)
	set_collision_mask_value(1, not is_drained)
	process_mode = Node.PROCESS_MODE_DISABLED if is_drained else Node.PROCESS_MODE_INHERIT
