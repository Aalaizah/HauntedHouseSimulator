extends Node

func _ready() -> void:
	Console.pause_enabled = true
	Console.add_command("score", score, ["amount"], 1, "Adds the amount to the current score")
	Console.add_command("fill_house", fill_house)
	
func score(amount):
	Global.score += int(amount)
	Console.print_line("Score adjusted by %s" % amount)
	
func fill_house():
	EventBus.fill_house_code_used.emit()
