class_name HitBox extends Area2D

signal Damaged(damage: int)

func TakeDamage(idOfHurtbox: int, damage: int) -> void:
	Damaged.emit(damage)
