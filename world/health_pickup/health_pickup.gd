class_name HealthPickup
extends Node2D

const TIME_TO_LIVE := 60.0

const SCENE := preload("res://world/health_pickup/health_pickup.tscn")
const sound := preload("res://audio/Cozy UI D1.wav")

var countdown : float

func _ready() -> void:
	$AnimationPlayer.play("rotate")
	countdown = TIME_TO_LIVE
	
func _process(delta: float) -> void:
	countdown -= delta
	if countdown <= 0:
		queue_free()

static func spawn_health_pickup(_pos: Vector2) -> HealthPickup:
	var pickup = SCENE.instantiate() as HealthPickup
	pickup.global_position = _pos
	return pickup

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		SignalBus.player_healed.emit(1)
		AudioPlayer.play_sound(sound)
		queue_free()
