class_name HealthPickupArea
extends Node2D

@export var collison_poly : CollisionPolygon2D
@export var health_spawn_cooldown: float


var triangles : Array[PackedVector2Array]
var areas : Array[float]
var total_area := 0.0
var poly: PackedVector2Array

var countdown: float

func _ready():
	poly = collison_poly.polygon
	_triangulate_polygon()
	countdown = health_spawn_cooldown
	
func _process(delta: float) -> void:
	countdown -= delta
	if countdown <= 0:
		countdown = health_spawn_cooldown
		spawn_health_pack()

func spawn_health_pack():
	var pos = get_random_point_in_polygon()
	add_child(HealthPickup.spawn_health_pickup(pos))

func _triangulate_polygon():
	triangles.clear()
	areas.clear()
	total_area = 0.0

	var indices = Geometry2D.triangulate_polygon(poly)

	for i in range(0, indices.size(), 3):
		var a = poly[indices[i]]
		var b = poly[indices[i + 1]]
		var c = poly[indices[i + 2]]

		triangles.append(PackedVector2Array([a, b, c]))

		var area = abs((b - a).cross(c - a)) * 0.5
		areas.append(area)
		total_area += area


func get_random_point_in_triangle(a: Vector2, b: Vector2, c: Vector2) -> Vector2:
	var r1 = sqrt(randf())
	var r2 = randf()

	return a + (b - a) * r1 * (1.0 - r2) + (c - a) * r1 * r2


func get_random_point_in_polygon() -> Vector2:
	var pick = randf() * total_area
	var acc = 0.0

	for i in triangles.size():
		acc += areas[i]
		if pick <= acc:
			var t = triangles[i]
			return get_random_point_in_triangle(t[0], t[1], t[2]) + $Area2D.global_position

	return $Area2D.global_position
