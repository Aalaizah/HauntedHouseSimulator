extends Node
@export var house_scene: PackedScene
@export var guest_scene: PackedScene
var last_room = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var guests = get_node("GuestPath").get_children()
	for guest in guests:
		var speed = guest.get_child(0).speed
		guest.set_progress(guest.get_progress() + speed * delta)
		if guest.get_progress_ratio() == 1:
			var score_to_add = (randi() % 5) + 1
			var score_multiplier = 1
			if guest.get_child(0).favorite_room in Global.current_rooms:
				score_multiplier = 2
			guest.queue_free()
			Global.score += score_to_add * score_multiplier
	get_node("DayTimer/DayTimerLabel").text = str(int(get_node("DayTimer").time_left))
	get_node("Score").text = str(Global.score)

func new_game():
	Global.score = 0
	var house = house_scene.instantiate()
	house.add_room(Vector2(0.0,0.0), "clown", Color(0, 1, 1))
	house.add_room(Vector2(0,1), "witches lair", Color(1, 1, 0))
	house.add_room(Vector2(1,0), "swamp", Color(0, 1, 0))
	house.add_room(Vector2(1,1), "forest", Color(1, 1, 1))
	house.add_room(Vector2(2,0), "classroom", Color(0.5, 0.5, 0))
	house.add_room(Vector2(2,1), "operating room", Color(0.5, 0.5, 0.5))
	house.z_index = 0
	add_child(house)
	new_guest_path()
	$GuestTimer.wait_time = randf_range(2, 6)
	$GuestTimer.start()
	$DayTimer.one_shot = true
	$DayTimer.start()
	
func new_guest_path():
	var path = $GuestPath.curve
	var room_center_point = Global.small_room_size / 2
	path.clear_points()
	path.add_point(Vector2(room_center_point, room_center_point))
	path.add_point(Vector2(room_center_point * 6, room_center_point))
	path.add_point(Vector2(room_center_point * 6, room_center_point * 3))
	path.add_point(Vector2(room_center_point, room_center_point * 3))
	
func get_room():
	var current_rooms = Global.current_rooms
	var random_room = current_rooms[randi() % current_rooms.size()]
	while random_room == last_room:
		random_room = current_rooms[randi() % current_rooms.size()]
	last_room = random_room
	return random_room

func _on_guest_timer_timeout() -> void:
	var guest_path = PathFollow2D.new()
	guest_path.rotates = false
	guest_path.loop = false
	get_node("GuestPath").add_child(guest_path)
	var guest = guest_scene.instantiate()
	guest.favorite_room = get_room()
	guest.z_index = 5
	guest_path.add_child(guest)
	$GuestTimer.wait_time = randf_range(0, 6)
	Global.score += 10


func _on_day_timer_timeout() -> void:
	$GuestTimer.stop()
	pass # Replace with function body.


func _on_new_day_pressed() -> void:
	$GuestTimer.start()
	$DayTimer.start()
