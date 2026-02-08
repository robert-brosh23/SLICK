class_name GameOverMenu
extends Control

@export var arrow : TextureRect
@export var options : Array[Node]

@export var agents_retired_label: Label

var options_index = 0

var song := preload("res://audio/Climb Intensity 1.wav")
var audio_stream_player: AudioStreamPlayer
var volume_tween : Tween

func _ready():
	_move_arrow_to(options[options_index])
	agents_retired_label.text = str(SignalBus.num_enemies_retired)
	audio_stream_player = AudioPlayer.play_sound(song, false, AudioPlayer.Bus.MUSIC, false)
	audio_stream_player.volume_db = -40.0
	tween_volume(audio_stream_player, 0.0, 0.25)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		options_index += 1
		options_index = options_index % options.size()
		_move_arrow_to(options[options_index])
	if Input.is_action_just_pressed("up"):
		options_index -= 1
		if options_index == -1:
			options_index = 2
		options_index = options_index % options.size()
		_move_arrow_to(options[options_index])
	if Input.is_action_just_pressed("space"):
		_handle_space()
		
	if audio_stream_player && audio_stream_player.playing:
		if audio_stream_player.get_playback_position() >= audio_stream_player.stream.get_length() - 3.823:
			audio_stream_player.queue_free()
			audio_stream_player = AudioPlayer.play_sound(song, false, AudioPlayer.Bus.MUSIC, false)

func _move_arrow_to(button: Control):
	arrow.global_position.y = button.global_position.y + button.size.y * 0.5 - arrow.size.y * 0.5

func _handle_space():
	match options_index:
		0:
			audio_stream_player.queue_free()
			get_tree().change_scene_to_file("res://main.tscn")
		1:
			audio_stream_player.queue_free()
			get_tree().change_scene_to_file("res://ui/menus/tile_screen/title_screen_menu.tscn")
			
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
