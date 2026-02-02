class_name Van
extends Node2D

class PenguinSpawnInfo:
	var delay_time: float
	var num_penguins: int

const SPEED := 150.0
const SCENE := preload("res://enemy/van/van.tscn")

@export var animation_player: AnimationPlayer

## false = left, true = right
var direction: boolean = false

var moving_left = false
var moving_right = false

static func spawn_van(pos: Vector2, _direction: bool, penguin_directions: Array[PenguinSpawnInfo]) -> Van:
	var van = SCENE.instantiate() as Van
	van.global_position = pos
	van.direction = _direction
	
func handle_spawn_info(penguin_spawn_infos: Array[PenguinSpawnInfo]):
	for info in penguin_spawn_infos:
		await drive(info.delay_time)
		await let_penguin_out(info.num_penguins)
	await drive(30.0)
	queue_free()

func _physics_process(delta: float) -> void:
	if moving_left:
		global_position.x -= SPEED * delta
	elif moving_right:
		global_position.x += SPEED * delta

func drive(drive_time: float):
	if direction:
		drive_right(drive_time)
	else:
		drive_left(drive_time)

func drive_left(drive_time: float):
	moving_left = true
	scale.x = 1.0
	await get_tree().create_timer(drive_time).timeout
	moving_left = false

func drive_right(drive_time: float):
	moving_right = true
	scale.x = -1.0
	await get_tree().create_timer(drive_time).timeout
	moving_right = false
	
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
