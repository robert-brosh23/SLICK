class_name BasicPenguin
extends CharacterBody2D

const SCENE = preload("res://enemy/basic_penguin.tscn")

@export var sprite: Sprite2D
@export var hitbox: HitBox
@export var state_machine: StateMachine
@export var check_walls_hurtbox: HurtBox

var run_away_direction : bool
var retired : bool
var aggroed : bool = false

static func spawn_penguin(_position: Vector2) -> BasicPenguin:
	var enemy: BasicPenguin = SCENE.instantiate()
	enemy.global_position = _position
	return enemy

func _ready():
	hitbox.Damaged.connect(_penguin_damaged)
	run_away_direction = randf() < 0.5
	retired = false
	
func _physics_process(delta: float) -> void:
	move_and_slide_isometric()

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
			
func move_and_slide_isometric():
	velocity.y *= 0.5
	move_and_slide()
	if get_slide_collision_count() > 0:
		velocity = velocity.bounce(get_slide_collision(0).get_normal()) * .8
	velocity.y *= 2.0
