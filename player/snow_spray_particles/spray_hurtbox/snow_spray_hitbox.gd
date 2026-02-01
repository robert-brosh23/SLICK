class_name SnowSprayHurtbox
extends Node2D

const SCENE = preload("res://player/snow_spray_particles/spray_hurtbox/snow_spray_hitbox.tscn")

@export var collision_shape: CollisionShape2D

var direction: Vector2
var speed: float
var time_to_live: float

static func spawn_and_shoot(_pos: Vector2, _direction: Vector2, _speed: float, _time_to_live: float = 1.0) -> SnowSprayHurtbox:
	var hurtbox : SnowSprayHurtbox = SCENE.instantiate()
	hurtbox.global_position = _pos
	hurtbox.direction = _direction
	hurtbox.speed = _speed
	hurtbox.time_to_live = _time_to_live
	return hurtbox
	
func _physics_process(delta: float) -> void:
	var velocity := speed * direction
	print(velocity)
	var motion := velocity * delta
	print(motion)
	global_position += motion

func _ready() -> void:
	_await_time_to_live_and_free()
	_gradually_expand_collision_shape()
	
func _await_time_to_live_and_free():
	await get_tree().create_timer(time_to_live).timeout
	queue_free()

func _gradually_expand_collision_shape():
	var shape = collision_shape.shape.duplicate() as CircleShape2D
	collision_shape.shape = shape
	
	while true:
		shape.radius += 4
		await get_tree().create_timer(.1).timeout
	
