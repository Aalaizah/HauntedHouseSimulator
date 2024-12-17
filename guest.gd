extends Node
var speed = 50
var favorite_room
var tip_multiplier = 1
var has_flipped: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = randf_range(100, 200)
	get_random_anim()
	get_room()
	
func guest_exited_house(maxTip: int):
	var score_to_add = (randi() % maxTip) + 1
	if Global.current_rooms.has(self.favorite_room):
		tip_multiplier = 2
	Global.score += score_to_add * tip_multiplier
		
func get_random_anim():
	var choices = $AnimatedSprite2D.sprite_frames.get_animation_names()
	var chosen = choices[randi_range(0, choices.size()-1)]
	if chosen == "walk-stick":
		self.scale.x = 0.25
		self.scale.y = 0.25
	$AnimatedSprite2D.play(chosen)
	
func get_room():
	if Global.all_rooms.size() > 0:
		var all_rooms = Global.all_rooms
		var room_names = all_rooms.keys()
		var random_room = room_names[randi() % all_rooms.size()]
		favorite_room = random_room
