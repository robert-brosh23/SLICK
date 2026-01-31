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
	var player_velocity_normalized = player.velocity.normalized() * -1
	var particle_spawn_angle := (Vector2.UP.rotated(player.player_rotation.rotation) + player_velocity_normalized).normalized()
	particle_spawn_angle.x *= -1.0
	particle_spawn_angle.y *= -1.0
	
	var particle_velocity = 50 + player.velocity.length() * .5
	
	var mat = continuous_spawner.process_material as ParticleProcessMaterial
	mat.direction = Vector3(particle_spawn_angle.x, particle_spawn_angle.y, 0)
	mat.initial_velocity_min = particle_velocity * 0.9
	mat.initial_velocity_max = particle_velocity * 1.1

func spawn_continuous():
	continuous_spawner.emitting = true

func stop_spawn_continuous():
	continuous_spawner.emitting = false
