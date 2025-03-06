extends Node3D

@export var end_scene: PackedScene
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("player colidiu com a porta")
		if body.keys == Global.total_keys:
			print("chaves completas")
			animation_player.play("open", 0.3)
			await get_tree().create_timer(2).timeout
			get_tree().quit()
