# Version 2 felt pretty interesting and like a step in the right direction, but
#  I was finding myself slamming wasd to try and turn and the Shift felt unintuitive.
#  It also felt like instant carpal tunnel, my hand was cramping after only a few
#  minutes of playing around with it. I think changing to wasd being instant inputs
#  would make movement feel way cooler and truer to form.

extends CharacterBody2D

const MAXSPEED_BASE := 1200.0 
const FRICTION_BASE := 150.0 # lower number means more sliding.
const KICKSTR := 400.0 # velocity given per button click.
const BRAKESTR := 10000.0 # excessively high to enable instant stops.
const KICK_CD := 0.08 # currently set only to block a macro spam click - included incase we want a cooldown.
const CHARGE_RATE := 5 * 1000.0
const CHARGE_MAX := 1500.0

var CD_count = KICK_CD
var maxSpeed := MAXSPEED_BASE
var friction := FRICTION_BASE
var chargePower : float


func _physics_process(delta: float) -> void:
	_handle_skate(delta)
	_handle_slip(delta)
	_handle_boost(delta)
	move_and_slide()


func _handle_skate(delta):
	CD_count -= delta
	if CD_count <= 0 and not Input.is_action_pressed("space"):
		if Input.is_action_just_pressed("left"):
			velocity.x -= KICKSTR
			CD_count = KICK_CD
		if Input.is_action_just_pressed("right"):
			velocity.x += KICKSTR
			CD_count = KICK_CD
		if Input.is_action_just_pressed("up"):
			velocity.y -= KICKSTR
			CD_count = KICK_CD
		if Input.is_action_just_pressed("down"):
			velocity.y += KICKSTR
			CD_count = KICK_CD
		if Input.is_action_just_pressed("shift"):
			velocity = velocity.move_toward(Vector2.ZERO, BRAKESTR)
			CD_count = KICK_CD

func _handle_slip(delta: float):
	var friction_step := friction * delta
	velocity = velocity.move_toward(Vector2.ZERO, friction_step)

func _handle_boost(delta: float):
	if Input.is_action_pressed("space"):
		chargePower += CHARGE_RATE * delta
		chargePower = min(chargePower, CHARGE_MAX)
	elif Input.is_action_just_released("space"):
		var mouse_dir = get_local_mouse_position().normalized()
		velocity = chargePower * mouse_dir
		chargePower = 0
