class_name ParticleSpawner
extends Node2D

@export var continuous_spawner : GPUParticles2D
@export var burst_spawner : GPUParticles2D
@export var player : Player

var last_rotation : float
var prev_particle_angle : Vector2
var prev_particle_velocity : float
var particle_spawn_angle: Vector2
var particle_velocity: float
	
func _physics_process(delta: float) -> void:
	var player_velocity_normalized = player.velocity.normalized() * -1
	
	var rotation_delta = _get_and_update_rotation_delta(delta)
	
	if rotation_delta > 0 && player.velocity.length() > 20.0:
		particle_spawn_angle = lerp(prev_particle_angle, (Vector2.UP.rotated(player.player_rotation.rotation) + player_velocity_normalized).normalized() * Vector2(-1.0,-1.0), 1.0 - exp(-8.0 * delta))
	else:
		particle_spawn_angle = lerp(prev_particle_angle, Vector2.UP.rotated(player.player_rotation.rotation) * Vector2(-1.0,-1.0), 1.0 - exp(-8.0 * delta))
		
	prev_particle_angle = particle_spawn_angle
	
	particle_velocity = lerp(prev_particle_velocity, 10 + (player.velocity.length() * 0.4) * (1000.0 * rotation_delta),  .1)
	prev_particle_velocity = particle_velocity
	
	var mat = continuous_spawner.process_material as ParticleProcessMaterial
	mat.direction = Vector3(particle_spawn_angle.x, particle_spawn_angle.y, 0)
	mat.initial_velocity_min = particle_velocity * 0.9
	mat.initial_velocity_max = particle_velocity * 1.1

func spawn_continuous():
	prev_particle_velocity = 100.0
	continuous_spawner.emitting = true
	spawn_hurtboxes()
	
func spawn_burst(charge_amount):
	var angle = Vector2.UP.rotated(player.player_rotation.rotation) * Vector2(-1.0,-1.0)
	var vel = charge_amount * .5
	spawn_burst_hurtboxes(angle, vel)
	add_child(BurstSpawner.create_burst_spawner(angle, vel))
	
func spawn_hurtboxes():
	while continuous_spawner.emitting:
		if player.player_controllable:
			get_tree().root.add_child(SnowSprayHurtbox.spawn_and_shoot(player.global_position, particle_spawn_angle, particle_velocity, 1))
			await get_tree().create_timer(.1).timeout
		else:
			return
		
func spawn_burst_hurtboxes(angle: Vector2, burst_velocity: float):
	get_tree().root.add_child(SnowSprayHurtbox.spawn_and_shoot(player.global_position, angle.rotated(-.35), burst_velocity, 1))
	get_tree().root.add_child(SnowSprayHurtbox.spawn_and_shoot(player.global_position, angle.rotated(-.15), burst_velocity, 1))
	get_tree().root.add_child(SnowSprayHurtbox.spawn_and_shoot(player.global_position, angle, burst_velocity, 1))
	get_tree().root.add_child(SnowSprayHurtbox.spawn_and_shoot(player.global_position, angle.rotated(.15), burst_velocity, 1))
	get_tree().root.add_child(SnowSprayHurtbox.spawn_and_shoot(player.global_position, angle.rotated(.35), burst_velocity, 1))
		

func stop_spawn_continuous():
	get_tree().root.add_child(SnowSprayHurtbox.spawn_and_shoot(player.global_position, particle_spawn_angle, particle_velocity, 1))
	continuous_spawner.emitting = false

func _get_and_update_rotation_delta(_delta: float) -> float:
	var current := player.player_rotation.rotation
	var delta_rotation := angle_difference(last_rotation, current) * _delta

	last_rotation = current
	return abs(delta_rotation)

#region deprecated
func spawn_snow_particles(velocity_direction: Vector2):
	var particles = SnowSprayParticles.spawn_particles(velocity_direction)
	add_child(particles)
	handle_particles_clear(particles)
	
func handle_particles_clear(particles: SnowSprayParticles):
	await get_tree().create_timer(1.0).timeout
	particles.queue_free()
#endregion
	
