class_name RunAwayState
extends EnemyBaseState

@export var base_sprite: Sprite2D

var active := false
var y_move := 0.0

func _ready():
	var y_move_timer := Timer.new()
	y_move_timer.wait_time = 1.0
	y_move_timer.autostart = true
	y_move_timer.timeout.connect(on_y_move_timer_timout)
	add_child(y_move_timer)

func enter():
	super()
	animation_tree.set("parameters/conditions/cry", true)
	active = true
	
func exit():
	super()
	animation_tree.set("parameters/conditions/cry", false)
	enemy.velocity = Vector2.ZERO
	active = false

func physics_update(_delta: float):
	var x_vel : float = 2000.0
	if !enemy.run_away_direction:
		x_vel *= -1
	enemy.velocity =  Vector2(x_vel, y_move) * _delta
			
func on_y_move_timer_timout():
	y_move = randf_range(-1000.0, 1000.0)
		
func on_damage_taken():
	Transitioned.emit(self, "DeadState")
