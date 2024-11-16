extends Control

signal restarted
signal moved_to_home
signal moved_to_high_score

func set_score_values(score: int, high_score:int) -> void:
	$Container/ScoreValueLabel.text = str(score)
	$Container/HighScoreValueLabel.text = str(high_score)


func _on_restart_touch_screen_button_released() -> void:
	restarted.emit()


func _on_home_touch_screen_button_released() -> void:
	moved_to_home.emit()


func _on_high_score_touch_screen_button_released() -> void:
	moved_to_high_score.emit()
