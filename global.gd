extends Node
var small_room_size = 200
var score = 0
var all_rooms = []
var current_rooms = []
var available_rooms = []
var available_room_names = {}
var house_size = 6
var rooms_load = [
	"res://Rooms(Resources)/Classroom.tres",
	"res://Rooms(Resources)/Clown.tres",
	"res://Rooms(Resources)/Forest.tres",
	"res://Rooms(Resources)/OperatingRoom.tres",
	"res://Rooms(Resources)/Swamp.tres",
	"res://Rooms(Resources)/Witch.tres",
	"res://Rooms(Resources)/Cemetery.tres",
	"res://Rooms(Resources)/Pirate.tres"
	]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#for i in rooms_load.size():
		#var item := RoomItem.new()
		#item.init(load(rooms_load[i]))
		#item.name = item.room_name
		#Global.available_rooms.append(item)
		#Global.all_rooms.append(item)
		#Global.available_room_names[item.name] = item


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
