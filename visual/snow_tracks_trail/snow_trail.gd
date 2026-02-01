class_name SnowTrail
extends Node2D

const POINT_LIFETIME := 5.0

@export var min_distance := 6.0
@export var player: Player

@export var trail_left: Line2D
@export var trail_right: Line2D

var accumulated_time := 0.0

func _physics_process(delta):
	accumulated_time += delta

	if accumulated_time > POINT_LIFETIME:
		accumulated_time = 0.0
		for i in range (0, trail_left.get_point_count() / 20):
			trail_left.remove_point(0)
			trail_right.remove_point(0)
			
	if player.velocity.length() < 5:
		return

	if trail_left.points.is_empty() \
	or trail_left.points[-1].distance_to(player.global_position) > min_distance:
		trail_left.add_point(_calculate_left_tread_pos())
		trail_right.add_point(_calculate_right_tread_pos())

func _calculate_left_tread_pos() -> Vector2:
	return Vector2.LEFT.rotated(player.player_rotation.rotation) * 5 * Vector2(1, 0.5) + player.global_position + Vector2(0, 1.5)

func _calculate_right_tread_pos() -> Vector2:
	return Vector2.RIGHT.rotated(player.player_rotation.rotation) * 5 * Vector2(1, 0.5) + player.global_position + Vector2(0, 1.5)
