extends Node2D

func _on_start_button_released() -> void:
	get_tree().change_scene_to_file("res://scenes/game_scene/game_scene.tscn")


func _on_high_score_button_released() -> void:
	pass


func _on_quit_button_released() -> void:
	get_tree().quit()
