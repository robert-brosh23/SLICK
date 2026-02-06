class_name IdleState
extends EnemyBaseState

var player: Player
var time_left: float

func enter() -> void:
	super()
	animation_tree.set("parameters/conditions/idle", true)
	player = get_tree().get_first_node_in_group("player")
	time_left = randf_range(MIN_TIME_LEFT, MAX_TIME_LEFT)
	if enemy.aggroed:
		enemy.aggroed = false
		SignalBus.enemy_left_range.emit()
	
func exit() -> void:
	super()
	animation_tree.set("parameters/conditions/idle", false)

func on_damage_taken():
	Transitioned.emit(self, "DeadState")

func physics_update(_delta: float):
	if (enemy.global_position * Vector2(1.0,2.0)).distance_to(player.global_position * Vector2(1.0,2.0)) < AGGRO_RANGE:
		Transitioned.emit(self, "MoveTowardState")
	 
	time_left -= _delta
	if time_left <= 0:
		if randf() < 0.7:
			Transitioned.emit(self, "MoveRandomState")
		else:
			Transitioned.emit(self, "IdleState")
