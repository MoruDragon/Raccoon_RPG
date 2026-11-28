@tool
extends Node

## Animations that should automatically play when the scene is loaded.
@export var starting_animations: Array[String]

## Variable in save_data for whether this dialogue has played already.
@export var seen_variable: StringName = "seen_opening"

## The dialogue resource that this scene uses.
@export var dialogue_resource: DialogueResource = preload("uid://jwje6kjck28p"):
	set(value):
		dialogue_resource = value
		notify_property_list_changed()

## The cue that the cutscene dialogue starts from.
@export var dialogue_cue: String = "start"

@export var cutscene_camera: Camera2D
@export var player_camera: Camera2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# If ran in the editor, check if save data flag is set correctly and return.
	if Engine.is_editor_hint():
		_assert_variables_are_valid()
		return
	
	# Do not play the cutscene if seen_variable is in the save_data and it is true.
	if GameState.save_data.get(seen_variable):
		return
	
	# Play any starting animations
	for anim in starting_animations:
		animation_player.play(anim)
	
	# Show the dialogue box from the start
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_cue, [self])


func pause_to_play_cutscene_anim(animation_name: String) -> void:
	animation_player.play(animation_name)
	await animation_player.animation_finished


func play_cutscene_anim(animation_name: String) -> void:
	animation_player.play(animation_name)


func wait_for_cutscene_anim(animation_name: String) -> void:
	if animation_player.is_playing() and animation_player.current_animation == animation_name:
		await animation_player.animation_finished


func switch_to_player_camera() -> void:
	var original_zoom := player_camera.zoom
	player_camera.global_position = cutscene_camera.global_position
	player_camera.zoom = cutscene_camera.zoom
	player_camera.make_current()
	var tween = create_tween().set_parallel()
	tween.tween_property(player_camera, "position", Vector2.ZERO, 0.5)
	tween.tween_property(player_camera, "zoom", original_zoom, 0.5)


func switch_to_cutscene_camera() -> void:
	var original_zoom := cutscene_camera.zoom
	cutscene_camera.global_position = player_camera.global_position
	cutscene_camera.zoom = player_camera.zoom
	cutscene_camera.make_current()
	var tween = create_tween()
	tween.tween_property(cutscene_camera, "zoom", original_zoom, 0.5)


#region Property Validation
## Gives the starting_animations and seen_variable property
## dropdowns of valid options.
## (nobody asked for this but I wanted to learn how to do it lol)
func _validate_property(property: Dictionary) -> void:
	if property.name == &"starting_animations":
		property.hint = PROPERTY_HINT_TYPE_STRING
		property.hint_string = "%d/%d:%s" % [
			TYPE_STRING,
			PROPERTY_HINT_ENUM,
			",".join(animation_player.get_animation_list())
		]
	if property.name == &"seen_variable":
		property.hint = PROPERTY_HINT_ENUM
		property.hint_string = ",".join(Util.get_save_data_variables())


func _assert_variables_are_valid() -> void:
	assert(seen_variable in Util.get_save_data_variables(),
		"'%s' is not a save data variable." % seen_variable)
	for anim in starting_animations:
		assert(anim in animation_player.get_animation_list(),
		"'%s' is not an animation in the current animation player." % anim)
#endregion
