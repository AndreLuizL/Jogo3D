extends Control

@export var game_scene: PackedScene

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)


func _on_instrucoes_btn_pressed() -> void:
	pass


func _on_sair_btn_pressed() -> void:
	get_tree().quit()
