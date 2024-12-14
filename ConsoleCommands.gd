extends Node

func _ready() -> void:
	Console.add_command("score", score, 1)
	
func score(amount):
	Global.score += int(amount)
	Console.print_line("Score adjusted by %s" % amount)
