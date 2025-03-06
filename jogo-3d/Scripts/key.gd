extends Area3D

func _process(delta):
	rotation_degrees.y += 60.0 * delta


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.collect_key()
		queue_free()
