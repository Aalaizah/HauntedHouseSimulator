extends Node

func _ready():
	get_node("NewGame").pressed.connect(_on_new_game_pressed)
	get_node("LoadGame").pressed.connect(_on_load_game_pressed)
	get_node("Settings").pressed.connect(_on_settings_pressed)
	get_node("Credits").pressed.connect(_on_credits_pressed)
	get_node("Quit").pressed.connect(_on_quit_pressed)

func _on_new_game_pressed() -> void:
	EventBus.start_new_game.emit()

func _on_load_game_pressed() -> void:
	EventBus.load_game.emit()
	
func _on_settings_pressed() -> void:
	pass
	
func _on_credits_pressed() -> void:
	pass
	
func _on_quit_pressed() -> void:
	print("bye")
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
	
