class_name Main
extends Node2D

var num_enemies: int
var audio_stream_player: AudioStreamPlayer

var song := preload("res://audio/Blizzard Main.wav")
var volume_tween: Tween

func _ready():
	num_enemies = 0
	
	audio_stream_player = AudioPlayer.play_sound(song, false, AudioPlayer.Bus.MUSIC, false)
	audio_stream_player.volume_db = -40.0
	tween_volume(audio_stream_player, -5.0, 0.5)
	SignalBus.player_died.connect(_on_player_died)

func _on_player_died():
	if audio_stream_player:
		tween_volume(audio_stream_player, -80.0, 2.0)
		await get_tree().create_timer(2.0).timeout
		audio_stream_player.queue_free()
		
func _process(delta: float) -> void:
	if audio_stream_player && audio_stream_player.playing:
		if audio_stream_player.get_playback_position() >= audio_stream_player.stream.get_length() - 2.419:
			audio_stream_player.queue_free()
			audio_stream_player = AudioPlayer.play_sound(song, false, AudioPlayer.Bus.MUSIC, false)
	
func tween_volume(player: AudioStreamPlayer, target_db: float, time: float):
	if volume_tween and volume_tween.is_running():
		volume_tween.kill()

	volume_tween = create_tween()
	volume_tween.tween_property(
		player,
		"volume_db",
		target_db,
		time
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
