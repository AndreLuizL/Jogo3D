extends RigidBody3D

const BROKEN_CRATE = preload("res://Prefab/broken_crate.tscn")
const COINS_RIGID = preload("res://Prefab/coins_rigid.tscn")

const MAX_DROP_COIN:= 5

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func destroy_crate():
	var broken_crate_instance:= BROKEN_CRATE.instantiate()
	add_sibling(broken_crate_instance)
	broken_crate_instance.global_position = global_position
	
	visible = false
	collision_shape_3d.set_deferred("disabled", true)
	drop_coin()
	await get_tree().create_timer(1.5).timeout
	queue_free()
	
func drop_coin():
	var num_coins_to_drop = randi() % (MAX_DROP_COIN + 1)
	for coins in range(num_coins_to_drop):
		var coin:= COINS_RIGID.instantiate()
		add_sibling(coin)
		coin.global_position = global_position
		coin.spawn_coin()
