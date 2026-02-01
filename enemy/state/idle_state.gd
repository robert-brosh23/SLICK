class_name IdleState
extends EnemyBaseState

func on_damage_taken():
	print("I'm dead")
	Transitioned.emit(self, "DeadState")
