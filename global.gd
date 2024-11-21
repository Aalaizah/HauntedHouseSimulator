extends Node
enum States {MAIN_MENU, STORE_OPEN, DAY_RUNNING, MODIFYING_HOUSE}
enum StoreStates {NO_STORE_AVAILABLE, ROOM_STORE_AVAILABLE, HOUSE_STORE_AVAILABLE}
var state: States = States.STORE_OPEN
var store_state = StoreStates.NO_STORE_AVAILABLE
var small_room_size = 200
var icon_size = 50
var score = 0
var all_rooms = {}
var current_rooms = {}
var inventory_rooms = {}
var store_inventory = {}
var house_inventory = {}
var current_house
var house_size = 6
var currentDay = 0
var rooms_load = [
	"res://Rooms(Resources)/Small Rooms/Resources/Classroom.tres",
	"res://Rooms(Resources)/Small Rooms/Resources/Clown.tres",
	"res://Rooms(Resources)/Small Rooms/Resources/Forest.tres",
	"res://Rooms(Resources)/Small Rooms/Resources/OperatingRoom.tres",
	"res://Rooms(Resources)/Small Rooms/Resources/Witch.tres",
	"res://Rooms(Resources)/Small Rooms/Resources/Pirate.tres",
	"res://Rooms(Resources)/Medium Rooms/Resources/Cemetery.tres",
	"res://Rooms(Resources)/Medium Rooms/Resources/Swamp.tres",
	"res://Rooms(Resources)/LargeRooms/Resources/Ocean.tres"
	]
var house_upgrades_load = [
	"res://Houses(Resources)/SmallHouse.tres",
	"res://Houses(Resources)/MediumHouse.tres",
	"res://Houses(Resources)/LargeHouse.tres"
]

func save():
	var save_dict = {
		"score": score
	}
	return save_dict

func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_data = save()
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
			
		var save_data = json.data
		for i in save_data.keys():
			set(i, save_data[i])
