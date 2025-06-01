extends Node
enum States {MAIN_MENU, STORE_OPEN, DAY_RUNNING, MODIFYING_HOUSE}
enum StoreStates {NO_STORE_AVAILABLE, ROOM_STORE_AVAILABLE, HOUSE_STORE_AVAILABLE}
enum TestingStates {NOT_TESTING, TESTING_DAY, TESTING_ROOM_STORE, TESTING_HOUSE_STORE}
var state: States = States.STORE_OPEN
var store_state = StoreStates.NO_STORE_AVAILABLE
var ticket_queue = []
var small_room_size = 432
var small_room_art_size = 432
var icon_size = 50
var score = 0
var ticket_price = 10
var guest_timer = 6
var all_rooms = {}
var current_rooms = {}
var inventory_rooms = {}
var store_inventory = {}
var house_inventory = {}
var current_house
var house_size = 6
var currentDay: int = 0
var currentMonth = 1
var maxTip = 5
var rooms_load = [
	"res://Rooms(Resources)/Small Rooms/Resources/Classroom.tres",
	"res://Rooms(Resources)/Small Rooms/Resources/Clown.tres",
	"res://Rooms(Resources)/Small Rooms/Resources/OperatingRoom.tres",
	"res://Rooms(Resources)/Small Rooms/Resources/Witch.tres",
	"res://Rooms(Resources)/Small Rooms/Resources/Pirate.tres",
	"res://Rooms(Resources)/Small Rooms/Resources/Cellar.tres",
	"res://Rooms(Resources)/Medium Rooms/Resources/Cemetery.tres",
	"res://Rooms(Resources)/Medium Rooms/Resources/Swamp.tres",
	"res://Rooms(Resources)/LargeRooms/Resources/Ocean.tres"
	]
#var rooms_load = [
	#"res://Rooms(Resources)/LargeRooms/Resources/",
	#"res://Rooms(Resources)/Medium Rooms/Resources/",
	#"res://Rooms(Resources)/Small Rooms/Resources/"
#]
var house_upgrades_load = [
	"res://Houses(Resources)/SmallHouse.tres",
	"res://Houses(Resources)/MediumHouse.tres",
	"res://Houses(Resources)/LargeHouse.tres"
]

func save():
	var save_dict = {
		"score": score,
		"current_house": current_house.data.name,
		"currentDay": currentDay,
		"player_inventory": inventory_rooms.keys(),
		"currentMonth": currentMonth
	}
	return save_dict


# current implementation load game must come after everything else is loaded
func load_game(json):
	var save_data = json.data
	for i in save_data.keys():
		if i == "player_inventory":
			for room in save_data[i]:
				EventBus.update_inventory.emit(room, 0)
			continue
		elif i == "house_data":
			var rooms = save_data[i]
			for room in rooms:
				#print(rooms[room])
				var room_name = rooms[room]
				if store_inventory.has(room_name):
					current_rooms[room_name] = store_inventory[room_name]
				EventBus.update_inventory.emit(room_name, 0)
				store_inventory.erase(room_name)
			EventBus.load_house.emit(save_data[i])
			continue
		elif i == "current_house":
			current_house = house_inventory[save_data[i]]
			house_size = current_house.data.house_size
		else:
			set(i, save_data[i])
