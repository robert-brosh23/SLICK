class_name TitleScreenMenu
extends Control

@export var animation_player: AnimationPlayer

var options_index = 0
var current_menu: Menu
var options : Array[Node]
var arrow : TextureRect

enum Menu {TITLE, OPTIONS, CREDITS, TUTORIAL}

@export var title: Control
@export var title_options_parent: Control

@export var options_menu: Control
@export var options_options_parent: Control
@export var master_slider: HSlider
@export var music_slider: HSlider
@export var sfx_slider: HSlider

@export var credits_menu: Control
@export var credits_options_parent: Control

@export var tutorial: Control

var volume_tween : Tween

var audio_stream_player: AudioStreamPlayer
var song := preload("res://audio/Moon Eyes Main.wav")

func _ready():
	_enter_title()
	audio_stream_player = AudioPlayer.play_sound(song, false, AudioPlayer.Bus.MUSIC, false)
	audio_stream_player.volume_db = -40.0
	tween_volume(audio_stream_player, -5.0, 0.5)
	_reset_sliders()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		_handle_down()
	if Input.is_action_just_pressed("up"):
		_handle_up()
	if Input.is_action_just_pressed("space"):
		_handle_space()
		
	if audio_stream_player && audio_stream_player.playing:
		if audio_stream_player.get_playback_position() >= audio_stream_player.stream.get_length() - 3.57:
			audio_stream_player.queue_free()
			audio_stream_player = AudioPlayer.play_sound(song, false, AudioPlayer.Bus.MUSIC, false)

func _enter_title():
	arrow = $Title/Arrow
	options_index = 0
	current_menu = Menu.TITLE
	options = title_options_parent.get_children()
	_move_arrow_to(options[options_index])
	title.visible = true
	animation_player.play("flash_controls")
	
func _exit_title():
	animation_player.stop()
	title.visible = false
	
func _enter_options():
	arrow = $Options/Arrow
	options_index = 0
	current_menu = Menu.OPTIONS
	options = options_options_parent.get_children()
	_move_arrow_to(options[options_index])
	options_menu.visible = true

func _exit_options():
	options_menu.visible = false
	
func _enter_credits():
	current_menu = Menu.CREDITS
	arrow = $Credits/Arrow
	options_index = 0
	options = credits_options_parent.get_children()
	_move_arrow_to(options[options_index])
	credits_menu.visible = true

func _exit_credits():
	credits_menu.visible = false
	
func _enter_tutorial():
	current_menu = Menu.TUTORIAL
	tutorial.visible = true
	
func _exit_tutorial():
	if audio_stream_player:
		tween_volume(audio_stream_player, -80.0, 0.2)
	tutorial.visible = false

func _move_arrow_to(button: Control):
	arrow.global_position.x = button.global_position.x
	arrow.global_position.y = button.global_position.y + button.size.y * 0.5 - arrow.size.y * 0.5

func _handle_up():
	match current_menu:
		Menu.TITLE:
			options_index -= 1
			if options_index == -1:
				options_index = 2
			options_index = options_index % options.size()
			_move_arrow_to(options[options_index])

func _handle_down():
	match current_menu:
		Menu.TITLE:
			options_index += 1
			options_index = options_index % options.size()
			_move_arrow_to(options[options_index])

func _handle_space():
	match current_menu:
		Menu.TITLE:
			match options_index:
				0:
					_exit_title()
					_enter_tutorial()
				2:
					_exit_title()
					_enter_options()
				1:
					_exit_title()
					_enter_credits()
		Menu.OPTIONS:
			_exit_options()
			_enter_title()
		Menu.CREDITS:
			_exit_credits()
			_enter_title()
		Menu.TUTORIAL:
			_exit_tutorial()
			audio_stream_player.queue_free()
			get_tree().change_scene_to_file("res://main.tscn")
			

func _on_h_slider_value_changed_master(value: float) -> void:
	if value < -39.9:
		value = -500
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	
func _on_h_slider_value_changed_music(value: float) -> void:
	if value < -39.9:
		value = -500
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_h_slider_value_changed_sfx(value: float) -> void:
	if value < -39.9:
		value = -500
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), value)
	
func _reset_sliders():
	master_slider.value = AudioPlayer.master_volume
	_on_h_slider_value_changed_master(master_slider.value)
	music_slider.value = AudioPlayer.music_volume
	_on_h_slider_value_changed_music(music_slider.value)
	sfx_slider.value = AudioPlayer.sfx_volume
	_on_h_slider_value_changed_sfx(sfx_slider.value)
	

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
