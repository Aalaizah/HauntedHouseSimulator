extends Node


func _on_button_pressed() -> void:
	EventBus.credits_closed.emit()
