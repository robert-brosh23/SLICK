class_name SnowSprayParticles
extends GPUParticles2D

const scene = preload("res://player/snow_spray_particles/snow_spray_particles.tscn")

static func spawn_particles(velocity_direction: Vector2) -> SnowSprayParticles:
	var scene : SnowSprayParticles = scene.instantiate()
	var mat := scene.process_material as ParticleProcessMaterial
	mat.direction = Vector3(velocity_direction.x, velocity_direction.y, 0.0)
	scene.emitting = true
	return scene
