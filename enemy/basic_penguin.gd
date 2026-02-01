class_name BasicPenguin
extends Node2D

@export var sprite: Sprite2D
@export var hitbox: HitBox
@export var state_machine: StateMachine

func _ready():
	hitbox.Damaged.connect(_penguin_damaged)

func _penguin_damaged(amount: int):
	var active_state = state_machine.active_state as EnemyBaseState
	active_state.on_damage_taken()

func _rotate_penguin_debug():
	while true:
		await get_tree().create_timer(.5).timeout
		if sprite.frame == 7:
			sprite.frame = 0
		else:
			sprite.frame += 1
