class_name Video
extends Control

@export var video_stream_player: VideoStreamPlayer

var countdown: float = 14.6
var mouse_pressed : bool = false

func _ready():
	await video_stream_player.finished
	get_tree().change_scene_to_file("res://ui/menus/tile_screen/title_screen_menu.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space") or (Input.is_action_just_pressed("mouse_left") and mouse_pressed) or Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://ui/menus/tile_screen/title_screen_menu.tscn")
	if Input.is_action_just_pressed("mouse_left"):
		mouse_pressed = true
	if video_stream_player.is_playing():
		countdown-= delta
		if countdown <= 0:
			get_tree().change_scene_to_file("res://ui/menus/tile_screen/title_screen_menu.tscn")
			
