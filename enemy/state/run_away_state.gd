class_name RunAwayState
extends EnemyBaseState

@export var base_sprite: Sprite2D
@export var animation_sprite: Sprite2D

var active := false

func enter():
	super()
	active = true
	start_animation()
	
func exit():
	super()
	animation_sprite.visible = false
	active = false

func physics_update(_delta: float):
	enemy.global_position.x -= _delta * 40.0

func start_animation():
	base_sprite.visible = false
	animation_sprite.visible = true
	animation_sprite.frame = 14
	while active:
		await get_tree().create_timer(.1).timeout
		if animation_sprite.frame == 17:
			animation_sprite.frame = 14
		else:
			animation_sprite.frame += 1
		
func on_damage_taken():
	print("I'm dead")
	Transitioned.emit(self, "DeadState")
