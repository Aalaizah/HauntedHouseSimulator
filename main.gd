extends Node
@export var guest_scene: PackedScene
var last_room
var store_open: bool
var day_ended: bool
var startingScore: int = 1000
var testingDay: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_node("Score").text = str(Global.score)
	var guests = get_node("GuestPath").get_children()
	var timer = get_node("DayTimer")
	for guest in guests:
		if guest.get_child_count() > 0:
			var speed = guest.get_child(0).speed
			guest.set_progress(guest.get_progress() + speed * delta)
		if guest.get_progress_ratio() == 1:
			guest.get_child(0).guest_exited_house()
			guest.queue_free()
	get_node("DayTimer/DayTimerLabel").text = str(int(timer.time_left))
	get_node("DayTimer/DayTimerProgress").value = timer.wait_time - timer.time_left
	if timer.time_left <= 0 and guests.size() == 0 and !store_open:
		$Hud/HUD/RoomScroll.show()
		$NewDay.show()
		$CloseStore.show()
		get_node("DayTimer/DayTimerProgress").hide()
		get_node("DayTimer/DayTimerLabel").hide()
		day_ended = true
	
func new_game():
	Global.score = startingScore
	day_ended = false
	new_guest_path()
	get_node("DayTimer/DayTimerProgress").max_value = get_node("DayTimer").wait_time
	if testingDay:
		var rooms = Global.all_rooms.keys()
		for i in Global.house_size:
			var current_house_slot = $Hud/HUD/HouseGrid.get_child(i)
			var room_to_add = Global.all_rooms[rooms[i]]
			if current_house_slot.get_child_count() == 0:
				current_house_slot.add_child(room_to_add)
				Global.current_rooms[room_to_add.name] = room_to_add
		store_open = false
		$CloseStore.text = "Open Store"
		$Hud/HUD/StoreInventoryScroll.hide()
		$Hud/HUD/HouseGrid.show()
		$HouseStore.hide()
	else:
		get_node("DayTimer/DayTimerProgress").hide()
		get_node("DayTimer/DayTimerLabel").hide()
		$Hud/HUD/HouseUpgradeInventory.hide()
		$HouseStore.hide()
		store_open = true
		$NewDay.hide()
	
func new_guest_path():
	var path = $GuestPath.curve
	var room_center_point = Global.small_room_size / 2.0
	var house_location = $Hud/HUD/HouseGrid.get_global_position()
	var half_house_size = Global.house_size / 2.0
	path.clear_points()
	path.add_point(Vector2(house_location.x - room_center_point, room_center_point + house_location.y))
	path.add_point(Vector2(room_center_point * Global.house_size,
		room_center_point + house_location.y))
	path.add_point(Vector2(room_center_point * Global.house_size, 
		room_center_point * half_house_size + house_location.y))
	path.add_point(Vector2(room_center_point - house_location.x, room_center_point * 
		half_house_size + house_location.y))
	
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
	guest_path.rotates = true
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
	var current_rooms = 0
	for room in $Hud/HUD/HouseGrid.get_children():
		if room.get_child_count() > 0:
			current_rooms += 1
	if day_over and Global.house_size == current_rooms:
		get_node("Score").show()
		get_node("DayTimer/DayTimerLabel").show()
		get_node("DayTimer/DayTimerProgress").show()
		$Hud/HUD/RoomScroll.hide()
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
		$Hud/HUD/StoreInventoryScroll.hide()
		$Hud/HUD/HouseGrid.show()
		$NewDay.show()
		$HouseStore.show()
	else:
		store_open = true
		$CloseStore.text = "Close Store"
		$Hud/HUD/StoreInventoryScroll.show()
		$Hud/HUD/HouseGrid.hide()
		$NewDay.hide()
		$HouseStore.hide()


func _on_audio_setting_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$MusicPlayer.stream_paused = false
	else:
		$MusicPlayer.stream_paused = true


func _on_house_store_pressed() -> void:
	if store_open == true:
		store_open = false
		$HouseStore.text = "Open House Store"
		$Hud/HUD/HouseUpgradeInventory.hide()
		$Hud/HUD/HouseGrid.show()
		$NewDay.show()
		$CloseStore.show()
	else:
		store_open = true
		$HouseStore.text = "Close House Store"
		$Hud/HUD/HouseUpgradeInventory.show()
		$Hud/HUD/HouseGrid.hide()
		$NewDay.hide()
		$CloseStore.hide()


func _on_button_pressed() -> void:
	save_game()


func _on_button_2_pressed() -> void:
	load_game()


func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_data = Global.save()
	save_data["house_data"] = $Hud/HUD.save_house()
	var json_string = JSON.stringify(save_data)
	save_file.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return
		
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), "in ", json_string, " at line ", json.get_error_line())
			continue
		Global.load_game(json)
