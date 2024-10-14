extends CanvasLayer

var HouseSize = Global.house_size
var InventorySize = 8
var roomsLoad = [
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
	%RoomStore.hide()
	for i in InventorySize:
		var inventorySlot := RoomInventory.new()
		inventorySlot.init(Vector2(200, 50))
		%RoomInventory.add_child(inventorySlot)
		
	
	for i in HouseSize:
		var slot := RoomSlot.new()
		slot.init(RoomData.Room_Size.SMALL, Vector2(200, 200))
		%HouseGrid.add_child(slot)
		
	for i in roomsLoad.size():
		var item := RoomItem.new()
		item.init(load(roomsLoad[i]))
		item.name = item.room_name
		Global.available_rooms.append(item)
		Global.all_rooms.append(item)
		%RoomInventory.get_child(i).add_child(item)
		%RoomInventory.get_child(i).add_label(item)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
