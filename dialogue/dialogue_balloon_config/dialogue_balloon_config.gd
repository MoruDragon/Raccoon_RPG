## Configuration for dialogue balloon per character.
##
## Found in res://dialogue/dialogue_balloon_config/.[br]
## Edit panels in the panels folder and set the panel theme override in balloon.tscn to test. [br]
class_name DialogueBalloonConfig
extends Resource

## Panel assigned to each character.
@export var panel: StyleBoxTexture = preload("uid://dluk1luet13wf")
## Color of the character name.
@export var name_color: Color = Color.BLACK
## Color of the dialogue text.
@export var dialogue_color: Color = Color.BLACK
