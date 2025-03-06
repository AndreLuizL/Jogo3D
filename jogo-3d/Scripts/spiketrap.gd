extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_timer_timeout():
	animation_player.play("show")
