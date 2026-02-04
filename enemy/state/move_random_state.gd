class_name MoveRandomState
extends EnemyBaseState

const MIN_SPEED = 20.0
const MAX_SPEED = 60.0

var time_left: float
var speed: float
var direction: Vector2

var player: Player

func enter():
	super()
	animation_tree.set("parameters/conditions/march", true)
	player = get_tree().get_first_node_in_group("player")
	time_left = randf_range(MIN_TIME_LEFT, MAX_TIME_LEFT)
	speed = randf_range(MIN_SPEED, MAX_SPEED)
	direction = Vector2.RIGHT.rotated(randf_range(0, 2*PI))
	
func exit():
	super()
	animation_tree.set("parameters/conditions/march", false)
	enemy.velocity = Vector2.ZERO

func on_damage_taken():
	Transitioned.emit(self, "DeadState")

func physics_update(_delta: float):
	enemy.velocity = direction * speed
	animation_tree.set("parameters/March/blend_position", IsometricUtil.to_iso(enemy.velocity).normalized())
	
	if (enemy.global_position * Vector2(1.0,2.0)).distance_to(player.global_position * Vector2(1.0,2.0)) < AGGRO_RANGE:
		Transitioned.emit(self, "MoveTowardState")
		
	time_left -= _delta
	if time_left <= 0:
		if randf() < 0.5:
			Transitioned.emit(self, "MoveRandomState")
		else:
			Transitioned.emit(self, "IdleState")
