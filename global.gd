extends Node
enum States {STORE_OPEN, DAY_RUNNING, MODIFYING_HOUSE}
var state: States = States.STORE_OPEN
var small_room_size = 200
var icon_size = 50
var score = 0
var all_rooms = {}
var current_rooms = {}
var available_rooms = {}
var store_inventory = {}
var hidden_slots = {}
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
