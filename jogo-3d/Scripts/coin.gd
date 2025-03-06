extends Area3D

const ROTATION_SPEED:= 50.0

@onready var start_pos:= position.y
@onready var end_pos:= position.y + 0.5

func _ready() -> void:
	var coin_tween:= create_tween().set_loops().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	coin_tween.tween_property(self, "position:y", end_pos, 1.0).from(start_pos)
	coin_tween.tween_property(self, "position:y", start_pos, 1.0).from(end_pos)


func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROTATION_SPEED * delta))


func _on_body_entered(body: Node3D) -> void:
	if body.name == "gobot":
		if body.has_method("collect_coins"):
			body.collect_coins()
			queue_free()
