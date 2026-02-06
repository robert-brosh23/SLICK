class_name Main
extends Node2D

@export var ovani_player: OvaniPlayer

var num_enemies: int

func _ready():
	num_enemies = 0
	ovani_player.Intensity = 1.0
