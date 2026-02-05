class_name EnemyBaseState
extends State

const MAX_TIME_LEFT := 5.0
const MIN_TIME_LEFT := 1.0
const AGGRO_RANGE := 300.0

@export var enemy: BasicPenguin
@export var animation_tree: AnimationTree

func on_damage_taken():
	pass
