class_name ChargeState
extends State

const CHARGE_SPEED := 400.0
const MAX_CHARGE := 400.0
const CHARGE_MANUVERABILITY_MAX := 7.0
const CHARGE_MANUVERABILITY_DECAY := 0.98
const CHARGE_MANUVERABILITY_MIN := 1.0
const BRAKE_CHARGE_FRICTION := 400.0

@export var player: Player
@export var charge_bar: ProgressBar
@export var particle_spawner: ParticleSpawner

var charge_amount: float
var charge_manuverability: float
var sound_drifting := preload("res://audio/snow_step_2.wav")
var audio_player: AudioStreamPlayer

var audio_countdown: float

func enter() -> void:
	super()
	charge_amount = 0.0
	charge_manuverability = CHARGE_MANUVERABILITY_MAX
	player.friction = BRAKE_CHARGE_FRICTION
	particle_spawner.spawn_continuous()
	audio_countdown = 0
	
	particle_spawner.last_rotation = player.player_rotation.rotation	
	
func physics_update(_delta: float):
	charge_amount = clamp(charge_amount + _delta * CHARGE_SPEED, 0.0, MAX_CHARGE)
	charge_manuverability = clamp(charge_manuverability * CHARGE_MANUVERABILITY_DECAY, CHARGE_MANUVERABILITY_MIN, CHARGE_MANUVERABILITY_MAX)
	charge_bar.value = charge_amount
	handle_audio(_delta)
	
	if Input.is_action_pressed("right"):
		player.player_rotation.rotate(charge_manuverability * _delta)
	elif Input.is_action_pressed("left"):
		player.player_rotation.rotate(-1.0 * charge_manuverability * _delta)
		
	if !Input.is_action_pressed("space"):
		_release_boost(_delta)
		
func handle_audio(_delta: float):
	audio_countdown -= _delta
	if audio_countdown <= 0:
		audio_player = AudioPlayer.play_sound(sound_drifting, true, AudioPlayer.Bus.SFX, false)
		audio_countdown = .03
		
func _release_boost(_delta: float):
	particle_spawner.stop_spawn_continuous()
	charge_bar.value = 0
	player.friction = player.FRICTION_BASE
	if audio_player != null:
		audio_player.queue_free()
	
	_big_burst()
	var boost_dir := Vector2.UP.rotated(player.player_rotation.rotation)
	player.force = boost_dir * charge_amount
	
	Transitioned.emit(self, "SkateState")
	
func _big_burst():
	particle_spawner.spawn_burst(charge_amount)
		
func _ready():
	charge_bar.max_value = MAX_CHARGE
