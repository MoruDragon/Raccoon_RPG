extends Node

@onready var music: AudioStreamPlayer = $Music
@onready var dialogue: AudioStreamPlayer = $Dialogue

func play_music(track: AudioStream) -> void:
	if track == null:
		return
	
	if music.stream == track and music.playing:
		return
	
	music.stream = track
	music.play()

func stop_music() -> void:
	music.stop()

func play_sfx(sound: AudioStream, volume_db: float = -6.0) -> void:
	if sound == null:
		return
	
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume_db
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()

func play_dialogue_blip(sound: AudioStream) -> void:
	if sound == null:
		return
	
	dialogue.stream = sound
	dialogue.play()

func stop_dialogue() -> void:
	dialogue.stop()
