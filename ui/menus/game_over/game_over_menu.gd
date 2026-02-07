class_name GameOverMenu
extends Control

@export var arrow : TextureRect
@export var options : Array[Node]
@export var ovani_player: OvaniPlayer

@export var agents_retired_label: Label

var options_index = 0

func _ready():
	_move_arrow_to(options[options_index])
	agents_retired_label.text = str(SignalBus.num_enemies_retired)
	ovani_player.Volume = -40.0
	ovani_player.FadeVolume(0.0, 0.25)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		options_index += 1
		options_index = options_index % options.size()
		_move_arrow_to(options[options_index])
	if Input.is_action_just_pressed("up"):
		options_index -= 1
		options_index = options_index % options.size()
		_move_arrow_to(options[options_index])
	if Input.is_action_just_pressed("space"):
		_handle_space()

func _move_arrow_to(button: Control):
	arrow.global_position.y = button.global_position.y + button.size.y * 0.5 - arrow.size.y * 0.5

func _handle_space():
	match options_index:
		0:
			get_tree().change_scene_to_file("res://main.tscn")
		1:
			get_tree().change_scene_to_file("res://ui/menus/tile_screen/title_screen_menu.tscn")
			
