class_name GameplayUI
extends Control

const STARTING_LIVES := 5

@export var life1: TextureRect
@export var lives_hbox: HBoxContainer

var lives: int

func _ready():
	_setup_lives()
	SignalBus.player_damaged.connect(_lose_life)
	SignalBus.player_healed.connect(_gain_life)
	
func _setup_lives():
	lives = STARTING_LIVES
	for i in lives - 1:
		lives_hbox.add_child(life1.duplicate())
	
func _gain_life(amount: int):
	for i in amount:
		lives_hbox.add_child(lives_hbox.get_child(0).duplicate())
	lives += amount
	print(lives)

func _lose_life():
	lives_hbox.remove_child(lives_hbox.get_child(0))
	lives -= 1
	
	if lives == 0:
		print("Game over")
