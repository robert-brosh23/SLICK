class_name DeadState
extends EnemyBaseState

@export var base_sprite: Sprite2D

func enter() -> void:
	super()
	animation_tree.set("parameters/conditions/slip", true)
	enemy.collision_mask = (1 << 2) | (1 << 3) | (1 << 4)
	await_get_up()
	
func await_get_up() -> void:
	await get_tree().create_timer(3.0).timeout
	animation_tree.set("parameters/conditions/slip", false)
	animation_tree.set("parameters/conditions/get_up", true)
	await animation_tree.animation_finished
	animation_tree.set("parameters/conditions/get_up", false)
	Transitioned.emit(self, "RunAwayState")
