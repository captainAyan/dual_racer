extends Control

signal start

func _on_start_button_released() -> void:
	start.emit()
