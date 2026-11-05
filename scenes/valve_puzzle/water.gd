extends AnimatedSprite2D

@export var barrier_collision: CollisionShape2D

func _ready() -> void:
	play()
	ValvePuzzleManager.puzzle_state_updated.connect(_on_puzzle_state_updated)

func _on_puzzle_state_updated(is_drained: bool) -> void:
	visible = not is_drained
	
	if barrier_collision:
		barrier_collision.set_deferred("disabled", is_drained)
