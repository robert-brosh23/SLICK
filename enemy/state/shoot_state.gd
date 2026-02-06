class_name ShootState
extends EnemyBaseState

const COUNTDOWN_TO_SHOOT := .25
const RECOIL_COUNTDOWN := 0.95

var player: Player
var shoot_countdown : float
var recoil_countdown: float

func enter() -> void:
	super()
	animation_tree.set("parameters/conditions/shoot", true)
	player = get_tree().get_first_node_in_group("player")
	shoot_countdown = COUNTDOWN_TO_SHOOT
	recoil_countdown = RECOIL_COUNTDOWN + COUNTDOWN_TO_SHOOT
	if !enemy.aggroed:
		enemy.aggroed = true
		SignalBus.enemy_entered_range.emit()
	
func exit():
	super()
	animation_tree.set("parameters/conditions/shoot", false)
	
func physics_update(_delta: float):
	shoot_countdown -= _delta
	recoil_countdown -= _delta
	var direction := (Vector2.LEFT.rotated(player.get_angle_to(enemy.global_position)) * Vector2(1.0, 2.0)).normalized()
	animation_tree.set("parameters/Shoot/blend_position", direction)
	if shoot_countdown <= 0.0:
		shoot_bullet()
		shoot_countdown = 100.0
	if recoil_countdown <= 0.0:
		Transitioned.emit(self, "MoveTowardState")

func shoot_bullet():
	var direction := (Vector2.LEFT.rotated(player.get_angle_to(enemy.global_position)) * Vector2(1.0, 2.0)).normalized()
	get_tree().get_first_node_in_group("world").add_child(Bullet.create_bullet(enemy.global_position, direction))
	
func on_damage_taken():
	Transitioned.emit(self, "DeadState")
