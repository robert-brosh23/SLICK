class_name BurstSpawner
extends GPUParticles2D

const SCENE := preload("res://player/snow_spray_particles/spawner/burst_spawner/burst_spawner.tscn")

var time_to_live: float

static func create_burst_spawner(angle: Vector2, velocity: float) -> BurstSpawner:
	var burst_spawner = SCENE.instantiate() as BurstSpawner
	burst_spawner.emitting = true
	burst_spawner.time_to_live = burst_spawner.lifetime
	var mat = burst_spawner.process_material as ParticleProcessMaterial
	mat.direction = Vector3(angle.x, angle.y, 0)
	mat.initial_velocity_min = velocity * 0.1
	mat.initial_velocity_max = velocity * 1.1
	burst_spawner.amount = velocity * .6
	return burst_spawner
	
func _process(delta: float) -> void:
	time_to_live -= delta
	if time_to_live <= 0.0:
		queue_free()
