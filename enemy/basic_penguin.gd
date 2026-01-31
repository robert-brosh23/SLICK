class_name BasicPenguin
extends Node2D

@export var sprite: Sprite2D

func _ready():
	while true:
		await get_tree().create_timer(.5).timeout
		if sprite.frame == 7:
			sprite.frame = 0
		else:
			sprite.frame += 1
		
