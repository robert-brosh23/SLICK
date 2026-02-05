class_name Player
extends CharacterBody2D

const FRICTION_BASE := .1

@export var animation_tree : AnimationTree
@export var player_rotation : Node2D
@export var sprite : Sprite2D
@export var hitbox : HitBox
@export var animation_player : AnimationPlayer

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
	animation_tree.set("parameters/AnimationNodeBlendSpace2D/blend_position", direction)
	
func move_and_slide_isometric():
	velocity.y *= 0.5

	var collision = move_and_collide(velocity * get_physics_process_delta_time())
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * 0.8
	
	velocity.y *= 2.0
	
	
	#velocity.y *= 0.5
	#move_and_slide()
	#if get_slide_collision_count() > 0:
		#var col = get_slide_collision(0)
		#var iso_normal = IsometricUtil.to_iso(col.get_normal()).normalized()
		#velocity = velocity.bounce(iso_normal) * 0.8
		#position += col.get_normal() * 0.5
		#print(velocity)
	#velocity.y *= 2.0
	
func _ready() -> void:
	hitbox.Damaged.connect(_player_damaged)
	
func _player_damaged(damage: int):
	animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	SignalBus.player_damaged.emit()
