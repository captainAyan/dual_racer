extends Node2D

func _ready():
	$Control/FirstHighScoreValueLabel.text = str(ScoreManager.high_scores[0])
	$Control/SecondHighScoreValueLabel.text = str(ScoreManager.high_scores[1])
	$Control/ThirdHighScoreValueLabel.text = str(ScoreManager.high_scores[2])


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene_to_file("res://scenes/menu_scene/menu_scene.tscn")


func _on_home_touch_screen_button_released() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_scene/menu_scene.tscn")
