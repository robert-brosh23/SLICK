class_name VanSpawner
extends Node2D

@export var direction: bool
@export var min_num_penguins: int
@export var max_num_penguins: int
@export var min_dropoff_delay: float
@export var max_dropoff_delay: float
@export var min_dropoffs: int
@export var max_dropoffs: int
@export var initial_delay_min: float
@export var initial_delay_max: float

var elapsed := 0.0

func _ready():
	await get_tree().create_timer(randf_range(initial_delay_min, initial_delay_max)).timeout
	while true:
		var num_dropoffs = randi_range(min_dropoffs,max_dropoffs)
		var spawn_infos : Array[Van.PenguinSpawnInfo] = []
		for i in num_dropoffs:
			var penguin_spawn_info = Van.PenguinSpawnInfo.new()
			penguin_spawn_info.delay_time = randf_range(min_dropoff_delay, max_dropoff_delay)
			penguin_spawn_info.num_penguins = randi_range(min_num_penguins, max_num_penguins)
			spawn_infos.append(penguin_spawn_info)
			
		var van = Van.spawn_van(global_position, direction, spawn_infos)
		get_tree().get_first_node_in_group("world").add_child(van)
		van.handle_spawn_info(van.spawn_info)
		await get_tree().create_timer(15.0 + (30.0 - 15.0) * exp(-8 * elapsed)).timeout
		
		
func _process(delta: float) -> void:
	elapsed += delta
