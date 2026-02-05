class_name HealthPickup
extends Node2D

const SCENE := preload("res://world/health_pickup/health_pickup.tscn")

func _ready() -> void:
	$AnimationPlayer.play("rotate")

static func spawn_health_pickup(_pos: Vector2) -> HealthPickup:
	var pickup = SCENE.instantiate() as HealthPickup
	pickup.global_position = _pos
	return pickup

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	if body is Player:
		SignalBus.player_healed.emit(1)
		queue_free()
