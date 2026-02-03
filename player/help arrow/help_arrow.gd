class_name HelpArrow
extends Node2D

const ARROW_OFFSET_AMOUNT := 20.0
const NEUTRAL_Y_OFFSET := -14.0

@export var player: Player

func _process(delta: float) -> void:
	var normalized_dir_vector := Vector2.UP.rotated(player.player_rotation.rotation)
	var isometric_dir := normalized_dir_vector * Vector2(1.0, 0.5)
	rotation = isometric_dir.angle() + PI/2.0
	position = isometric_dir * ARROW_OFFSET_AMOUNT + Vector2(0,NEUTRAL_Y_OFFSET)
