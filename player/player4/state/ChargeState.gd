class_name ChargeState
extends State

const CHARGE_SPEED := 500.0
const MAX_CHARGE := 600.0
const CHARGE_MANUVERABILITY_MAX := 5.0
const CHARGE_MANUVERABILITY_DECAY := 0.98
const BRAKE_CHARGE_FRICTION := .96
const INITIAL_BOOST_VELOCITY_OVERRIDE_DECAY := .5

@export var player: Player
@export var charge_bar: ProgressBar

var charge_amount: float
var charge_manuverability: float

func enter() -> void:
	super()
	charge_amount = 0.0
	charge_manuverability = CHARGE_MANUVERABILITY_MAX
	player.friction = BRAKE_CHARGE_FRICTION

func physics_update(_delta: float):
	charge_amount = clamp(charge_amount + _delta * CHARGE_SPEED, 0.0, MAX_CHARGE)
	charge_manuverability *= CHARGE_MANUVERABILITY_DECAY
	
	charge_bar.value = charge_amount
	
	if Input.is_action_pressed("right"):
		player.rotate(charge_manuverability * _delta)
	elif Input.is_action_pressed("left"):
		player.rotate(-1.0 * charge_manuverability * _delta)

	if !Input.is_action_pressed("space"):
		charge_bar.value = 0
		
		player.velocity *= INITIAL_BOOST_VELOCITY_OVERRIDE_DECAY
		player.friction = player.FRICTION_BASE
		player.force = Vector2.UP.rotated(player.rotation) * charge_amount
		Transitioned.emit(self, "SkateState")
		
func _ready():
	charge_bar.max_value = MAX_CHARGE
