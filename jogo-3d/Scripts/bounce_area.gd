extends Area3D
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@export var bounce_impulse:= 2.0




func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		animation_player.play("jumped", 0.3)
		body.gravity = -body.JUMP_VELOCITY * bounce_impulse
