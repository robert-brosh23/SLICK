class_name Van
extends Node2D

const SPEED := 150.0

@export var animation_player: AnimationPlayer

var moving_left = false

func _physics_process(delta: float) -> void:
	if moving_left:
		global_position.x -= SPEED * delta

func drive_left(drive_time: float):
	moving_left = true
	await get_tree().create_timer(drive_time).timeout
	moving_left = false
	
func let_penguin_out(num_penguins: int = 1):
	animation_player.play("open_door")
	await animation_player.animation_finished
	for i in range(0,num_penguins):
		animation_player.play("penguin_get_out")
		await animation_player.animation_finished
		var penguin = BasicPenguin.spawn_penguin(global_position + Vector2(6,5))
		get_tree().root.add_child(penguin)
	animation_player.play("close_door")
	await animation_player.animation_finished
	
func _ready() -> void:
	await drive_left(3.0)
	await let_penguin_out(4)
	await drive_left(11.0)
