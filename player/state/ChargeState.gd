class_name ChargeState
extends State

const CHARGE_SPEED := 500.0
const MAX_CHARGE := 600.0
const CHARGE_MANUVERABILITY_MAX := 7.0
const CHARGE_MANUVERABILITY_DECAY := 0.98
const BRAKE_CHARGE_FRICTION := .96
const INITIAL_BOOST_VELOCITY_OVERRIDE_DECAY := .5

@export var player: Player
@export var charge_bar: ProgressBar
@export var particle_spawner: ParticleSpawner

var charge_amount: float
var charge_manuverability: float

var last_rotation : float

func enter() -> void:
	super()
	charge_amount = 0.0
	charge_manuverability = CHARGE_MANUVERABILITY_MAX
	player.friction = BRAKE_CHARGE_FRICTION
	
	last_rotation = player.player_rotation.rotation	
	
func physics_update(_delta: float):
	charge_amount = clamp(charge_amount + _delta * CHARGE_SPEED, 0.0, MAX_CHARGE)
	charge_manuverability *= CHARGE_MANUVERABILITY_DECAY
	
	charge_bar.value = charge_amount
	
	if Input.is_action_pressed("right"):
		player.player_rotation.rotate(charge_manuverability * _delta)
	elif Input.is_action_pressed("left"):
		player.player_rotation.rotate(-1.0 * charge_manuverability * _delta)

	if _get_rotation_delta(_delta) >= .0001:
		particle_spawner.spawn_continuous()
		
	if !Input.is_action_pressed("space"):
		_release_boost(_delta)
		
		
func _release_boost(_delta: float):
	particle_spawner.stop_spawn_continuous()
	charge_bar.value = 0
	player.velocity *= INITIAL_BOOST_VELOCITY_OVERRIDE_DECAY
	player.friction = player.FRICTION_BASE
	player.force = Vector2.UP.rotated(player.player_rotation.rotation) * charge_amount
	Transitioned.emit(self, "SkateState")
	
func _get_rotation_delta(_delta: float) -> float:
	var current := player.player_rotation.rotation
	var delta_rotation := angle_difference(last_rotation, current) * _delta

	last_rotation = current
	print (abs(delta_rotation))
	return abs(delta_rotation)
		
func _ready():
	charge_bar.max_value = MAX_CHARGE
