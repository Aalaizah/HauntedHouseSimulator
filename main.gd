extends Node
@export var guest_scene: PackedScene
var last_room
var store_open: bool
var day_ended: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var guests = get_node("GuestPath").get_children()
	var timer = get_node("DayTimer")
	for guest in guests:
		var speed = guest.get_child(0).speed
		guest.set_progress(guest.get_progress() + speed * delta)
		if guest.get_progress_ratio() == 1:
			var score_to_add = (randi() % 5) + 1
			var score_multiplier = 1
			if Global.current_rooms.has(guest.get_child(0).favorite_room):
				score_multiplier = 2
			guest.queue_free()
			Global.score += score_to_add * score_multiplier
	get_node("DayTimer/DayTimerLabel").text = str(int(timer.time_left))
	get_node("Score").text = str(Global.score)
	get_node("DayTimer/ProgressBar").value = timer.wait_time - timer.time_left
	#if (Global.currentDay % 7 == 0 and day_ended):
		#store_open = true
		#$Hud/HUD/HouseGrid.hide()
		#$Hud/HUD/StoreInventory.show()
		#$CloseStore.show()
		#day_ended = false
	if timer.time_left <= 0 and guests.size() == 0 and !store_open:
		$Hud/HUD/RoomInventory.show()
		$NewDay.show()
		$CloseStore.show()
		get_node("DayTimer/ProgressBar").hide()
		get_node("DayTimer/DayTimerLabel").hide()
		day_ended = true
	
func new_game():
	Global.score = 1000
	day_ended = false
	new_guest_path()
	get_node("DayTimer/ProgressBar").max_value = get_node("DayTimer").wait_time
	get_node("DayTimer/ProgressBar").hide()
	get_node("DayTimer/DayTimerLabel").hide()
	store_open = true
	$NewDay.hide()
	
func new_guest_path():
	var path = $GuestPath.curve
	var room_center_point = Global.small_room_size / 2.0
	var house_location = $Hud/HUD/HouseGrid.get_global_position()
	path.clear_points()
	path.add_point(Vector2(house_location.x - room_center_point, room_center_point + house_location.y))
	path.add_point(Vector2(room_center_point * 6 + house_location.x, room_center_point + house_location.y))
	path.add_point(Vector2(room_center_point * 6 + house_location.x, room_center_point * 3 + house_location.y))
	path.add_point(Vector2(room_center_point - house_location.x, room_center_point * 3 + house_location.y))
	
func get_room():
	if Global.all_rooms.size() > 0:
		var all_rooms = Global.all_rooms
		var room_names = all_rooms.keys()
		var random_room = room_names[randi() % all_rooms.size()]
		while random_room == last_room:
			random_room = room_names[randi() % all_rooms.size()]
		last_room = random_room
		return random_room

func _on_guest_timer_timeout() -> void:
	var guest_path = PathFollow2D.new()
	guest_path.rotates = false
	guest_path.loop = false
	get_node("GuestPath").add_child(guest_path)
	var guest = guest_scene.instantiate()
	guest.z_index = 5
	guest.favorite_room = get_room()
	guest_path.add_child(guest)
	$GuestTimer.wait_time = randf_range(0, 6)
	Global.score += 10


func _on_day_timer_timeout() -> void:
	$GuestTimer.stop()


func _on_new_day_pressed() -> void:
	$CloseStore.hide()
	get_node("NewDay").hide()
	var day_over = $DayTimer.is_stopped()
	if day_over and Global.house_size == Global.current_rooms.size():
		get_node("DayTimer/ProgressBar").show()
		get_node("Score").show()
		get_node("DayTimer/DayTimerLabel").show()
		$Hud/HUD/RoomInventory.hide()
		$GuestTimer.wait_time = randf_range(2, 6)
		$GuestTimer.start()
		$DayTimer.one_shot = true
		$DayTimer.start()
		day_ended = false
		Global.currentDay += 1


func _on_close_store_pressed() -> void:
	if store_open == true:
		store_open = false
		$CloseStore.text = "Open Store"
		$Hud/HUD/StoreInventory.hide()
		$Hud/HUD/HouseGrid.show()
	else:
		store_open = true
		$CloseStore.text = "Close Store"
		$Hud/HUD/StoreInventory.show()
		$Hud/HUD/HouseGrid.hide()
