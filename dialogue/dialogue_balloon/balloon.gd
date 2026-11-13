extends CanvasLayer
## A basic dialogue balloon for use with Dialogue Manager.

## The dialogue resource
@export var dialogue_resource: DialogueResource

## Start from a given cue when using balloon as a [Node] in a scene.
@export var start_from_cue: String = ""

## If running as a [Node] in a scene then auto start the dialogue.
@export var auto_start: bool = false

## If all other input is blocked as long as dialogue is shown.
@export var will_block_other_input: bool = true

## The action to use for advancing the dialogue
@export var next_action: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
@export var skip_action: StringName = &"ui_cancel"

## A sound player for voice lines (if they exist).
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

## jamie test for character portraits
#@onready var portrait: TextureRect = $Balloon/Portrait

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## A dictionary to store any ephemeral variables
var locals: Dictionary = {}

var _locale: String = TranslationServer.get_locale()

## The current line
var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
			apply_dialogue_line()
		else:
			# The dialogue has finished so close the balloon
			if owner == null:
				queue_free()
			else:
				hide()
	get:
		return dialogue_line

## A cooldown timer for delaying the balloon hide when encountering a mutation.
var mutation_cooldown: Timer = Timer.new()

## The base balloon anchor
@onready var balloon: Control = %Balloon

## The label showing the name of the currently speaking character
@onready var character_label: RichTextLabel = %CharacterLabel

## The label showing the currently spoken dialogue
@onready var dialogue_label: DialogueLabel = %DialogueLabel

## The menu of responses
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu

## Indicator to show that player can progress dialogue.
@onready var progress: Polygon2D = %Progress

## Portrait of current character. Changes texture based on [member current_character] and
## [member expression] through a match statement in [method _update_character_portrait].
@onready var portrait: TextureRect = %Portrait

## Stores the speaking character. This is so the character can still show
## while there is no "speaker".
var current_character: String
## Stores the character's expression so it only needs to be tagged once to change it.
var expression := "neutral"

## All expressions that characters can have. Add more as needed.
const EXPRESSIONS = [
	"neutral",
	"happy",
	"surprised",
	"angry",
	"thinking",
	"mischievious",
	"embarrassed",
	"flustered",
	"prideful",
	"nervous",
	"confused",
	"sad",
	"nervous",
	"loving",
]

## Configurations for each character's visual style. Ctrl+Click
## on [DialogueBalloonConfig] for more information.
const BALLOON_CONFIG: Dictionary[String, DialogueBalloonConfig] = {
	"roro": preload("uid://btgdtpx704y76"),
	"macaron": preload("uid://c5age4tbqemmn"),
	"xiu": preload("uid://bg8oqjc8u0bdi"),
	"rat king": preload("uid://ctoywlikcndrr"),
	"random rat": preload("uid://bg8oqjc8u0bdi"),
	"paltry pigeon": preload("uid://c5age4tbqemmn"),
	"": preload("uid://btgdtpx704y76"),
}

## Reference to the panel container in order to change the theme to the character.
@onready var panel: PanelContainer = $Balloon/MarginContainer/PanelContainer


func _ready() -> void:
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

	# If the responses menu doesn't have a next action set, use this one
	if responses_menu.next_action.is_empty():
		responses_menu.next_action = next_action

	mutation_cooldown.timeout.connect(_on_mutation_cooldown_timeout)
	add_child(mutation_cooldown)

	if auto_start:
		if not is_instance_valid(dialogue_resource):
			assert(false, DMConstants.get_error_message(DMConstants.ERR_MISSING_RESOURCE_FOR_AUTOSTART))
		start()



func _process(_delta: float) -> void:
	if is_instance_valid(dialogue_line):
		progress.visible = not dialogue_label.is_typing and dialogue_line.responses.size() == 0 and not dialogue_line.has_tag("voice")


func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	if will_block_other_input:
		get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	## Detect a change of locale and update the current dialogue line to show the new language
	if what == NOTIFICATION_TRANSLATION_CHANGED and _locale != TranslationServer.get_locale() and is_instance_valid(dialogue_label):
		_locale = TranslationServer.get_locale()
		var visible_ratio: float = dialogue_label.visible_ratio
		await dialogue_line.refresh()
		if visible_ratio < 1:
			dialogue_label.skip_typing()


## Start some dialogue
func start(with_dialogue_resource: DialogueResource = null, cue: String = "", extra_game_states: Array = []) -> void:
	temporary_game_states = [self] + extra_game_states
	is_waiting_for_input = false
	if is_instance_valid(with_dialogue_resource):
		dialogue_resource = with_dialogue_resource
	if not cue.is_empty():
		start_from_cue = cue
	dialogue_line = await dialogue_resource.get_next_dialogue_line(start_from_cue, temporary_game_states)
	show()


## Apply any changes to the balloon given a new [DialogueLine].
func apply_dialogue_line() -> void:
	mutation_cooldown.stop()

	progress.hide()
	is_waiting_for_input = false
	balloon.focus_mode = Control.FOCUS_ALL
	balloon.grab_focus()
	
	## test for certain lines T_T - jamie
	character_label.visible = not dialogue_line.character.is_empty() and not dialogue_line.has_tag("hide_name")
	character_label.text = tr(dialogue_line.character, "dialogue")


	# jamie tried
	#var portrait_path: String = "res://assets/roro_portraits/%s/roro_neutral.png" % dialogue_line.character
	#if ResourceLoader.exists(portrait_path):
		#portrait.texture = load(portrait_path)
	#else:
		#portrait.texture = null

	dialogue_label.hide()
	dialogue_label.dialogue_line = dialogue_line

	responses_menu.hide()
	responses_menu.responses = dialogue_line.responses

	_update_character_portrait()
	
	# Show our balloon
	balloon.show()
	will_hide_balloon = false

	dialogue_label.show()
	if not dialogue_line.text.is_empty():
		dialogue_label.type_out()
		await dialogue_label.finished_typing

	# Wait for next line
	if dialogue_line.has_tag("voice"):
		audio_stream_player.stream = load(dialogue_line.get_tag_value("voice"))
		audio_stream_player.play()
		await audio_stream_player.finished
		next(dialogue_line.next_id)
	elif dialogue_line.responses.size() > 0:
		balloon.focus_mode = Control.FOCUS_NONE
		responses_menu.show()
	elif dialogue_line.time != "":
		var time: float = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
		await get_tree().create_timer(time).timeout
		next(dialogue_line.next_id)
	else:
		is_waiting_for_input = true
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()


## Go to the next line
func next(next_id: String) -> void:
	dialogue_line = await dialogue_resource.get_next_dialogue_line(next_id, temporary_game_states)


## Updates the character portrait based on the character and any tags.
func _update_character_portrait() -> void:
	# Exit early if there is no portrait to show.
	if not portrait:
		return
	
	# Stores the character name for upcoming dialogue lines in the variable current_character.
	# Lowered so that it can match with keys in BALLOON_CONFIG.
	if dialogue_line.character:
		current_character = dialogue_line.character.to_lower()
	
	# If a tag with a dialogue line matches a string in EXPRESSIONS, 
	# set the current expression to that string.
	for tag in dialogue_line.tags:
		if tag in EXPRESSIONS:
			expression = tag	# Variable to store the current expression.
			break				# Stop looking through the tags if an expression is found.
	
	# Update character portrait based on current_character and expression.
	match current_character:
		"roro":	# Add more branches as more characters are added. 
			match expression:
				"neutral":
					portrait.texture = load("res://assets/character portraits/roro_portraits/roro_neutral.png")
				"surprised":
					portrait.texture = load("res://assets/character portraits/roro_portraits/roro_surprised.png")
				"thinking":
					portrait.texture = load("res://assets/character portraits/roro_portraits/roro_thinking.png")
				"nervous":
					portrait.texture = load("res://assets/character portraits/roro_portraits/roro_nervous.png")
				"mischievious":
					portrait.texture = load("res://assets/character portraits/roro_portraits/roro_mischievous.png")
				"happy":
					portrait.texture = load("res://assets/character portraits/roro_portraits/roro_happy.png")
				_:	# Fallback sprite. 
					portrait.texture = load("res://assets/character portraits/roro_portraits/roro_neutral.png")
			portrait.show()
		"macaron":
			match expression:
				"neutral":
					portrait.texture = load("res://assets/character portraits/macaron_portraits/macaron_neutral.png")
				"surprised":
					portrait.texture = load("res://assets/character portraits/xiu_portraits/xiu_surprised.png")
				"prideful":
					portrait.texture = load("res://assets/character portraits/macaron_portraits/macaron_prideful.png")
				"happy":
					portrait.texture = load("res://assets/character portraits/macaron_portraits/macaron_happy.png")
				"flustered":
					portrait.texture = load("res://assets/character portraits/xiu_portraits/xiu_flustered.png")
				"angry":
					portrait.texture = load("res://assets/character portraits/macaron_portraits/macaron_angry.png")
			portrait.show()
		"xiu":
			match expression:
				"neutral":
					portrait.texture = load("res://assets/character portraits/xiu_portraits/xiu_neutral.png")
				"surprised":
					portrait.texture = load("res://assets/character portraits/xiu_portraits/xiu_surprised.png")
				"nervous":
					portrait.texture = load("res://assets/character portraits/xiu_portraits/xiu_nervous.png")
				"sad":
					portrait.texture = load("res://assets/character portraits/xiu_portraits/xiu_sad.png")
				"loving":
					portrait.texture = load("res://assets/character portraits/xiu_portraits/xiu_loving.png")
				"happy":
					portrait.texture = load("res://assets/character portraits/xiu_portraits/xiu_happy.png")
				"flustered":
					portrait.texture = load("res://assets/character portraits/xiu_portraits/xiu_flustered.png")
			portrait.show()
		_:
			portrait.hide()
	
	# Gets the configuration of balloon panel and font color that match the character.
	# Uses the dictionary get method, which falls back to null if not found.
	var config: DialogueBalloonConfig = BALLOON_CONFIG.get(current_character)
	# Only change the visuals if a config exists
	if config:
		# Update panel visual
		panel.add_theme_stylebox_override("panel", config.panel)
		
		# Update colors
		character_label.add_theme_color_override("default_color", config.name_color)
		dialogue_label.add_theme_color_override("default_color", config.dialogue_color)


#region Signals


func _on_mutation_cooldown_timeout() -> void:
	if will_hide_balloon:
		will_hide_balloon = false
		balloon.hide()


func _on_mutated(mutation: Dictionary) -> void:
	if not mutation.is_inline:
		is_waiting_for_input = false
		will_hide_balloon = true
		mutation_cooldown.start(0.1)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)


#endregion
