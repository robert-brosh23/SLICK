class_name Player
extends CharacterBody2D

const FRICTION_BASE := .1

@export var animation_tree : AnimationTree
@export var player_rotation : Node2D

var force := Vector2(0.0,0.0)
var friction : float = FRICTION_BASE

func _physics_process(delta: float) -> void:
	_handle_slip(delta)
	_handle_animation()
	move_and_slide_isometric()

func _handle_slip(delta: float):
	velocity += force * delta * 100
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
func _handle_animation():
	var up_rotated = Vector2.UP.rotated(player_rotation.rotation)
	var direction = Vector2(up_rotated.x, -1.0 * up_rotated.y)
	animation_tree.set("parameters/blend_position", direction)
	
func move_and_slide_isometric():
	velocity.y *= 0.5
	move_and_slide()
	velocity.y *= 2.0
