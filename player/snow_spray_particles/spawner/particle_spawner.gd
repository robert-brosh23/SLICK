class_name ParticleSpawner
extends Node2D

@export var continuous_spawner : GPUParticles2D
@export var player : Player

func spawn_snow_particles(velocity_direction: Vector2):
	var particles = SnowSprayParticles.spawn_particles(velocity_direction)
	print(velocity_direction)
	add_child(particles)
	handle_particles_clear(particles)
	
func handle_particles_clear(particles: SnowSprayParticles):
	await get_tree().create_timer(1.0).timeout
	particles.queue_free()
	
func _process(delta: float) -> void:
	var player_direction_vector := Vector2.UP.rotated(player.player_rotation.rotation)
	player_direction_vector *= Vector2(-0.75, 0)
	player_direction_vector += Vector2(0, -1.0)
	var mat = continuous_spawner.process_material as ParticleProcessMaterial
	mat.direction = Vector3(player_direction_vector.x, player_direction_vector.y, 0)

func spawn_continuous():
	continuous_spawner.emitting = true

func stop_spawn_continuous():
	continuous_spawner.emitting = false
