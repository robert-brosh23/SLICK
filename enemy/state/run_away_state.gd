class_name RunAwayState
extends EnemyBaseState

func enter():
	enemy.sprite.frame = 2

func physics_update(_delta: float):
	enemy.global_position.x -= _delta * 40.0
