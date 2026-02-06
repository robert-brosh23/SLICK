extends Node

signal player_damaged

signal player_healed(amount: int)

signal enemy_retired

signal enemy_entered_range
signal enemy_left_range
var num_enemies_nearby: int
