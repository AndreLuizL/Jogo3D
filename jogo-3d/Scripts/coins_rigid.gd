extends RigidBody3D

const MIN_SPAWN_RANGE:= 1.0
const MAX_SPAWN_RANGE:= 3.0
const MIN_SPAWN_HEIGHT:= 2.0
const MAX_SPAWN_HEIGHT:= 4.0

func spawn_coin():
	var random_height:= MIN_SPAWN_HEIGHT + (randf() * MAX_SPAWN_HEIGHT)
	var random_dir:= Vector3.FORWARD.rotated(Vector3.UP, randf() * 3 * PI)
	var random_pos:= random_dir * (MIN_SPAWN_RANGE + (randf() * MAX_SPAWN_RANGE))
	random_pos.y = random_height
	apply_central_impulse(random_pos)
