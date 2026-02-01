class_name SnowTrail
extends Node2D

@export var min_distance := 6.0
@export var player: Player

@export var trail_left: Line2D
@export var trail_right: Line2D

func _physics_process(delta):
	if player.velocity.length() < 5:
		return

	if trail_left.points.is_empty() \
	or trail_left.points[-1].distance_to(player.global_position) > min_distance:
		trail_left.add_point(_calculate_left_tread_pos())
		trail_right.add_point(_calculate_right_tread_pos())

	if trail_left.points.size() > 100:
		trail_left.remove_point(0)
		
	if trail_right.points.size() > 100:
		trail_right.remove_point(0)

func _calculate_left_tread_pos() -> Vector2:
	return Vector2.LEFT.rotated(player.player_rotation.rotation) * 5 + player.global_position

func _calculate_right_tread_pos() -> Vector2:
	return Vector2.RIGHT.rotated(player.player_rotation.rotation) * 5 + player.global_position
