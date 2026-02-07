class_name Main
extends Node2D

@export var ovani_player: OvaniPlayer

var num_enemies: int

func _ready():
	num_enemies = 0
	ovani_player.Intensity = 1.0
	ovani_player.Volume = -40.0
	ovani_player.FadeVolume(-5.0, 0.5)
	SignalBus.player_died.connect(_on_player_died)

func _on_player_died():
	ovani_player.FadeVolume(-80.0, 2.0)
	
