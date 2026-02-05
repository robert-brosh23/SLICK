class_name GameplayUI
extends Control

const STARTING_LIVES := 5

@export var life1: TextureRect
@export var lives_hbox: HBoxContainer
@export var enemies_retired_label: RichTextLabel

var lives: int
var enemies_retired: int
var tween : Tween

func _ready():
	_setup_lives()
	enemies_retired = 0
	SignalBus.player_damaged.connect(_lose_life)
	SignalBus.player_healed.connect(_gain_life)
	SignalBus.enemy_retired.connect(_enemy_retired)
	
func _setup_lives():
	lives = STARTING_LIVES
	for i in lives - 1:
		lives_hbox.add_child(life1.duplicate())
	
func _gain_life(amount: int):
	if lives <= 0:
		return
	for i in amount:
		lives_hbox.add_child(lives_hbox.get_child(0).duplicate())
	lives += amount

func _lose_life():
	lives_hbox.remove_child(lives_hbox.get_child(0))
	lives -= 1
	
	if lives == 0:
		print("Game over")
		
func _enemy_retired():
	enemies_retired += 1
	enemies_retired_label.text = str(enemies_retired)
	_punch_retired_text()
	
func _punch_retired_text():
	# Kill existing tween (this handles interruption cleanly)
	if tween and tween.is_running():
		tween.kill()

	# Instantly grow
	enemies_retired_label.add_theme_font_size_override("normal_font_size", 36)

	
	tween = create_tween()
	tween.tween_interval(.2)
	tween.tween_property(
		enemies_retired_label,
		"theme_override_font_sizes/normal_font_size",
		18,
		.2
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)	
	
