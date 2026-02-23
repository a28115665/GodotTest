extends Node
## Simple audio manager for BGM and SFX.

var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

var current_bgm: String = ""

func _ready() -> void:
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Master"
	bgm_player.volume_db = -5.0
	add_child(bgm_player)

	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "Master"
	add_child(sfx_player)

func play_bgm(music_name: String) -> void:
	if music_name == current_bgm and bgm_player.playing:
		return
	current_bgm = music_name
	var path = "res://assets/audio/music/" + music_name + ".ogg"
	if ResourceLoader.exists(path):
		bgm_player.stream = load(path)
		bgm_player.play()

func stop_bgm() -> void:
	bgm_player.stop()
	current_bgm = ""

func play_sfx(sfx_name: String) -> void:
	var path = "res://assets/audio/sfx/" + sfx_name + ".wav"
	if ResourceLoader.exists(path):
		sfx_player.stream = load(path)
		sfx_player.play()
