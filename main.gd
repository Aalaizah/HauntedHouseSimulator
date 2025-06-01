extends Node
@export var guest_scene: PackedScene
@export var credits_scene: PackedScene
var last_room
var store_open: bool
var day_ended: bool
var startingScore: int = 1000
var ticketPurchaseText: String = "+ 10"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.fill_house_code_used.connect(house_code)
	EventBus.credits_closed.connect(_on_credits_closed)
	EventBus.start_new_game.connect(_on_new_game_pressed)
	EventBus.load_game.connect(load_game)
	%TicketDisplayTimer.wait_time = Global.guest_timer / 2.0
	Console.enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_node("Score").text = str(Global.score)
	var guests = get_node("Hud/HUD/HouseViewContainer/HouseView/GuestPath").get_children()
	var timer = get_node("DayTimer")
	for guest in guests:
		if guest.get_child_count() > 0:
			var speed = guest.get_child(0).speed
			guest.set_progress(guest.get_progress() + speed * delta)
		if guest.get_progress_ratio() > .5 and guest.get_child(0).has_flipped == false:
			guest.get_child(0).get_child(0).flip_h = true
			guest.get_child(0).has_flipped = true
		if guest.get_progress_ratio() == 1:
			var tip = guest.get_child(0).guest_exited_house(Global.maxTip)
			Global.score += tip
			show_tip(tip)
			guest.queue_free()
	get_node("DayTimer/DayTimerLabel").text = str(int(timer.time_left))
	get_node("DayTimer/DayTimerProgress").value = timer.wait_time - timer.time_left
	if timer.time_left <= 0 and guests.size() == 0 and Global.store_state == Global.StoreStates.NO_STORE_AVAILABLE:
		$Hud/HUD/RoomScroll.show()
		$NewDay.show()
		$SaveButton.show()
		$LoadButton.show()
		clear_message_queue(Global.ticket_queue)
		get_node("DayTimer/DayTimerProgress").hide()
		get_node("DayTimer/DayTimerLabel").hide()
		day_ended = true
		Global.state = Global.States.MODIFYING_HOUSE
		if Global.currentDay == 28:
			Global.currentMonth += 1
			Global.currentDay = 0
			Global.store_state = Global.StoreStates.HOUSE_STORE_AVAILABLE
			$HouseStore.show()
			$CloseStore.show()
		elif Global.currentDay % 7 == 0:
			$CloseStore.show()
	
func show_tip(tipAmount: int):
	add_to_message_queue(Global.ticket_queue, str(tipAmount))
	%TicketDisplayTimer.start()
	
func show_ticket_purchase():
	add_to_message_queue(Global.ticket_queue, ticketPurchaseText)
	%TicketDisplayTimer.start()

func new_game():
	Global.score = startingScore
	day_ended = false
	get_node("DayTimer/DayTimerProgress").max_value = get_node("DayTimer").wait_time
	get_node("DayTimer/DayTimerProgress").hide()
	get_node("DayTimer/DayTimerLabel").hide()
	$Hud/HUD/HouseUpgradeInventory.hide()
	$Hud/HUD/HouseViewContainer.hide()
	$HouseStore.hide()
	store_open = true
	$NewDay.hide()
	
func new_guest_path():
	var path = $Hud/HUD/HouseViewContainer/HouseView/GuestPath.curve
	var room_center_point = Global.small_room_size / 2.0
	var top_room_visible_center = (Global.small_room_size / 3.0) * 2
	var bottom_room_visible_center = (Global.small_room_size / 3.0) * 5
	var house_location = $Hud/HUD/HouseViewContainer/HouseView/HouseHBoxContainer/HouseGrid.position
	path.clear_points()
	path.add_point(Vector2(house_location.x - room_center_point, top_room_visible_center + house_location.y))
	path.add_point(Vector2((room_center_point * Global.house_size) + (room_center_point * 1.75),
		top_room_visible_center + house_location.y))
	path.add_point(Vector2((room_center_point * Global.house_size) + (room_center_point * 1.75), 
		bottom_room_visible_center+ house_location.y))
	path.add_point(Vector2(house_location.x - room_center_point, bottom_room_visible_center
		+ house_location.y))

func _on_guest_timer_timeout() -> void:
	var guest_path = PathFollow2D.new()
	guest_path.rotates = false
	guest_path.loop = false
	get_node("Hud/HUD/HouseViewContainer/HouseView/GuestPath").add_child(guest_path)
	var guest = guest_scene.instantiate()
	guest.z_index = 5
	guest_path.add_child(guest)
	$GuestTimer.wait_time = randf_range(0, Global.guest_timer)
	show_ticket_purchase()
	Global.score += Global.ticket_price

func _on_day_timer_timeout() -> void:
	$GuestTimer.stop()

func _on_new_day_pressed() -> void:
	Global.state = Global.States.DAY_RUNNING
	new_guest_path()
	$CloseStore.hide()
	$HouseStore.hide()
	$SaveButton.hide()
	$LoadButton.hide()
	get_node("NewDay").hide()
	var day_over = $DayTimer.is_stopped()
	var current_rooms = 0
	for room in $Hud/HUD/HouseViewContainer/HouseView/HouseHBoxContainer/HouseGrid.get_children():
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
		Global.store_state = Global.StoreStates.NO_STORE_AVAILABLE

func _on_close_store_pressed() -> void:
	if store_open == true:
		store_open = false
		$CloseStore.text = "Buy Rooms"
		$Hud/HUD/StoreInventoryScroll.hide()
		$Hud/HUD/HouseViewContainer.show()
		$NewDay.show()
		$HouseStore.show()
	else:
		store_open = true
		$CloseStore.text = "Close Store"
		$Hud/HUD/StoreInventoryScroll.show()
		$Hud/HUD/HouseViewContainer.hide()
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
		$Hud/HUD/HouseViewContainer.show()
		$NewDay.show()
		$CloseStore.show()
	else:
		store_open = true
		$HouseStore.text = "Close House Store"
		$Hud/HUD/HouseUpgradeInventory.show()
		$Hud/HUD/HouseViewContainer.hide()
		$NewDay.hide()
		$CloseStore.hide()

func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_data = Global.save()
	save_data["house_data"] = $Hud/HUD.save_house()
	var json_string = JSON.stringify(save_data)
	save_file.store_line(json_string)

func load_game():
	$MainMenu/MainMenu/AudioSetting.reparent(self)
	get_node("AudioSetting").toggled.connect(_on_audio_setting_toggled)
	remove_child(get_node("./MainMenu"))
	if not FileAccess.file_exists("user://savegame.save"):
		return
	new_game()	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), "in ", json_string, " at line ", json.get_error_line())
			continue
		Global.load_game(json)
	store_open = false
	$CloseStore.text = "Buy Rooms"
	$Hud/HUD/StoreInventoryScroll.hide()
	$Hud/HUD/HouseViewContainer.show()
	$Hud/HUD/RoomScroll.show()
	$NewDay.show()

func _on_new_game_pressed() -> void:
	$MainMenu/MainMenu/AudioSetting.reparent(self)
	get_node("AudioSetting").toggled.connect(_on_audio_setting_toggled)
	remove_child(get_node("./MainMenu"))
	new_game()
	Console.enabled = true

func _on_quit_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func house_code():
	var rooms = Global.all_rooms.keys()
	for i in Global.house_size:
		var current_house_slot = $Hud/HUD/HouseViewContainer/HouseView/HouseHBoxContainer/HouseGrid.get_child(i)
		var room_to_add = Global.all_rooms[rooms[i]]
		if current_house_slot.get_child_count() == 0:
			current_house_slot.add_child(room_to_add)
			Global.current_rooms[room_to_add.name] = room_to_add
			$Hud/HUD/StoreInventoryScroll/StoreInventory.get_node(NodePath(room_to_add.name)).queue_free()
			Global.store_inventory.erase(room_to_add.name)
			EventBus.update_inventory_testing_day.emit()
	store_open = false
	$CloseStore.text = "Buy Rooms"
	$Hud/HUD/StoreInventoryScroll.hide()
	$Hud/HUD/HouseViewContainer.show()
	$HouseStore.hide()
	$Hud/HUD/HouseUpgradeInventory.hide()
	Console.print_line("House filled")


func _on_credits_pressed() -> void:
	var credits = credits_scene.instantiate()
	get_node(".").add_child(credits)
	
func _on_credits_closed() -> void:
	remove_child(get_node("./Credits"))


func _on_ticket_display_timer_timeout() -> void:
	remove_from_message_queue(Global.ticket_queue)
	update_ticket_text()

func add_to_message_queue(queue, message: String) -> void:
	queue.push_back(message)
	update_ticket_text()

func remove_from_message_queue(queue) -> void:
	queue.pop_front()
	
func clear_message_queue(queue) -> void:
	queue.clear()
	update_ticket_text()
	
func update_ticket_text() -> void:
	var queue_size: int = Global.ticket_queue.size()
	%TicketBought.text = ""
	%TicketBought2.text = ""
	%TicketBought3.text = ""
	if queue_size >= 1:
		%TicketBought.text = Global.ticket_queue[0]
		%TicketBought2.text = ""
		%TicketBought3.text = ""
	if queue_size >= 2:
		%TicketBought2.text = Global.ticket_queue[1]
		%TicketBought3.text = ""
	if queue_size >= 3:
		%TicketBought3.text = Global.ticket_queue[2]
