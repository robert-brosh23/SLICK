class_name DeadState
extends EnemyBaseState

func enter() -> void:
	super()
	enemy.sprite.frame = 4
	print("Dead state entered")
	await_get_up()
	
func await_get_up() -> void:
	await get_tree().create_timer(5.0).timeout
	Transitioned.emit(self, "RunAwayState")
