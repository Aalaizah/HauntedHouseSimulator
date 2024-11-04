extends RigidBody2D
var speed = 50
var favorite_room
var tip_multiplier = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = randf_range(100, 200)
	$AnimatedSprite2D.play()
	
func guest_exited_house():
	var score_to_add = (randi() % 5) + 1
	var score_multiplier = 1
	if Global.current_rooms.has(self.favorite_room):
		score_multiplier = 2
		Global.score += score_to_add * score_multiplier
