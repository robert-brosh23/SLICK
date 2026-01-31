class_name Player
extends CharacterBody2D

const FRICTION_BASE := .995

var force := Vector2(0.0,0.0)
var friction : float = FRICTION_BASE

func _physics_process(delta: float) -> void:
	_handle_slip(delta)
	move_and_slide()

func _handle_slip(delta: float):
	velocity += force
	velocity *= friction
