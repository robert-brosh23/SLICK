class_name DeadState
extends EnemyBaseState

@export var base_sprite: Sprite2D
@export var animation_sprite: Sprite2D

func enter() -> void:
	super()
	print("Dead state entered")
	play_fall_animation()
	await_get_up()
	
func play_fall_animation():
	base_sprite.visible = false
	animation_sprite.visible = true
	animation_sprite.frame = 0
	for i in range(1,5):
		await get_tree().create_timer(.08).timeout
		animation_sprite.frame += 1
	
func await_get_up() -> void:
	await get_tree().create_timer(3.0).timeout
	animation_sprite.frame = 6
	for i in range(6,12):
		await get_tree().create_timer(.08).timeout
		animation_sprite.frame += 1
	Transitioned.emit(self, "RunAwayState")
