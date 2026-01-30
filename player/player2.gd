# Kind of combines the boost concept robert mentioned with a stopping mechanic.
# Basic idea is that hitting shift 'kicks off' so it can be used for stopping and starting.

extends CharacterBody2D

const MAXSPEED_BASE := 3000.0
const ACCEL_BASE := 60.0
const FRICTION_BASE := 150.0
const KICK_BOOST := 30000.0
const KICK_FRICTION := 300000.0

var maxSpeed := MAXSPEED_BASE
var friction : float
var acceleration : float
var input_dir : Vector2

func _physics_process(delta: float) -> void:
	_handle_kick()
	_handle_dir()
	_handle_move(delta)

func _handle_kick():
	if Input.is_action_just_pressed("shift"):
		acceleration = KICK_BOOST
		friction = KICK_FRICTION
	else:
		acceleration = ACCEL_BASE
		friction = FRICTION_BASE

func _handle_dir():
	input_dir = Input.get_vector("left","right","up","down")

func _handle_move(delta: float):
	# if there's a direction input, accelerate to target speed
	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		velocity += input_dir * acceleration * delta
		if velocity.length() > maxSpeed:
			velocity = velocity.normalized() * maxSpeed
	# if no inputs, slide based on friction
	else:
		var friction_step := friction * delta
		velocity = velocity.move_toward(Vector2.ZERO, friction_step)

	move_and_slide()
