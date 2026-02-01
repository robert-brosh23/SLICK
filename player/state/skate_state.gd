class_name SkateState
extends State

const SKATE_ACCELERATION := 2.5
const SKATE_MANUVERABILITY := 1.5
const BRAKE_FRICTION := .95

@export var player: Player

func physics_update(_delta: float):
	if Input.is_action_just_pressed("space"):
		player.force = Vector2.ZERO
		Transitioned.emit(self, "ChargeState")
		return
		
	player.force = Vector2.UP.rotated(player.player_rotation.rotation) * SKATE_ACCELERATION
		
	if Input.is_action_pressed("right"):
		player.player_rotation.rotate(SKATE_MANUVERABILITY * _delta)
	elif Input.is_action_pressed("left"):
		player.player_rotation.rotate(-1.0 * SKATE_MANUVERABILITY * _delta)
