class_name Bullet
extends Node2D

const SPEED := 200.0
const SCENE := preload("res://enemy/bullet/bullet.tscn")
const LIFETIME := 2.0

@export var hurtbox: HurtBox

var direction: Vector2 = Vector2(1,0)
var countdown: float

static func create_bullet(_pos: Vector2, _direction: Vector2) -> Bullet:
	var bullet := SCENE.instantiate() as Bullet
	bullet.global_position = _pos
	bullet.direction = _direction
	return bullet

func _ready() -> void:
	hurtbox.OnHitConnect.connect(on_hurtbox_connect)
	countdown = LIFETIME

func on_hurtbox_connect():
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += IsometricUtil.to_iso(direction * SPEED * delta)
	countdown -= delta
	
	if countdown <= 0.0:
		queue_free()
	
