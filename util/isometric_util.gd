class_name IsometricUtil

static func to_iso(to_convert: Vector2) -> Vector2:
	return to_convert * Vector2(1.0, 0.5)

static func from_iso(to_convert: Vector2) -> Vector2:
	return to_convert * Vector2(1.0, 2.0)
