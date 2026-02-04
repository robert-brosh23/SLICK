class_name MoveTowardState
extends EnemyBaseState

const SPEED := 60.0
const LOSE_INTEREST_DISTANCE := 500.0
const SHOOT_DISTANCE := 200.0

var player: Player

func enter():
	super() 
	animation_tree.set("parameters/conditions/march", true)
	player = get_tree().get_first_node_in_group("player")
	
func exit():
	super()
	animation_tree.set("parameters/conditions/march", false)
	enemy.velocity = Vector2.ZERO 

func on_damage_taken():
	Transitioned.emit(self, "DeadState")

func physics_update(_delta: float):
	enemy.velocity = Vector2(1.0,2.0) * Vector2.RIGHT.rotated(player.get_angle_to(enemy.global_position)) * SPEED * -1.0
	animation_tree.set("parameters/March/blend_position", IsometricUtil.to_iso(enemy.velocity).normalized())
	if (enemy.global_position * Vector2(1.0,2.0)).distance_to(player.global_position * Vector2(1.0,2.0)) > LOSE_INTEREST_DISTANCE:
		Transitioned.emit(self, "IdleState")
	if (enemy.global_position * Vector2(1.0,2.0)).distance_to(player.global_position * Vector2(1.0,2.0)) < SHOOT_DISTANCE:
		Transitioned.emit(self, "ShootState")
