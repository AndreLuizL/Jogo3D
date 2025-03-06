extends RigidBody3D


const SPREAD_PIECES:= 4
const SPREAD_POWER:= 350

@onready var pieces_index:= [0,1,2,3]

func _ready():
	pieces_index.shuffle()
	
	for pieces in range(SPREAD_PIECES):
		var piece_index: int = pieces_index[pieces]
		var piece: RigidBody3D = get_child(piece_index)
		piece.show()
		piece.freeze = false
		piece.sleeping = false
		piece.set_collision_mask_value(1, true)
		
		var rand_direction = (Vector3.ONE * 0.25) - Vector3(randf(), randf(), randf())
		piece.apply_force(rand_direction * SPREAD_POWER, rand_direction)
		


func _process(delta: float) -> void:
	pass


func _on_stop_move_timeout() -> void:
	freeze = true
	await get_tree().create_timer(2.0).timeout
	queue_free()
