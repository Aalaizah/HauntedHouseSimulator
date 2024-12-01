extends Node
var speed = 50
var favorite_room
var tip_multiplier = 1
var has_flipped: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = randf_range(100, 200)
	#$AnimatedSprite2D.play()
	get_random_anim()
	
func guest_exited_house():
	var score_to_add = (randi() % 5) + 1
	var score_multiplier = 1
	if Global.current_rooms.has(self.favorite_room):
		score_multiplier = 2
		Global.score += score_to_add * score_multiplier
		
func get_random_anim():
	var choices = $AnimatedSprite2D.sprite_frames.get_animation_names()
	var chosen = choices[randi_range(0, choices.size()-1)]
	if chosen == "walk-stick":
		self.scale.x = 0.25
		self.scale.y = 0.25
	$AnimatedSprite2D.play(chosen)
