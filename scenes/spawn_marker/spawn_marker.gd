extends Marker2D

@export var marker_tag: String = ""
@export_file("*.tscn") var target_scene_path: String = ""
@export var cooldown_delay: float = 0.01

@onready var trigger_area: Area2D = $Area2D

var is_player_inside: bool = false
var can_trigger: bool = false

func _ready() -> void:
	add_to_group("spawn_markers")
	
	if not trigger_area:
		push_error("[SpawnMarker] ERROR: Child Area2D node not found on marker '", marker_tag, "'")
		return

	trigger_area.body_entered.connect(_on_body_entered)
	trigger_area.body_exited.connect(_on_body_exited)
	
	# Disarm trigger if the player spawns on this marker
	if not marker_tag.is_empty() and SceneManager.target_marker_tag == marker_tag:
		can_trigger = false
		is_player_inside = true
	else:
		can_trigger = true

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
		
	is_player_inside = true
	
	if can_trigger:
		can_trigger = false
		SceneManager.transition_to_map(target_scene_path, marker_tag)

func _on_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
		
	is_player_inside = false
	
	await get_tree().create_timer(cooldown_delay).timeout
	
	if is_inside_tree() and not is_player_inside:
		can_trigger = true
