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
		Global.store_inventory[item.name] = item
		Global.all_rooms[item.name] = item
		
	%HouseGrid.hide()
	
	for i in Global.store_inventory:
		var item = StoreItem.new()
		var panel = PanelContainer.new()
		item.init(Global.store_inventory[i].data)
		panel.add_child(item)
		panel.name = item.data.room_name
		%StoreInventory.add_child(panel)
		
	EventBus.room_bought.connect(add_room_to_player_inventory)
		
	
		
func add_room_to_player_inventory(room_name: String):
	var purchasePrice = Global.store_inventory[room_name].data.price
	if (Global.score > purchasePrice 
	and !Global.available_rooms.has(room_name)):
		Global.available_rooms[room_name] = Global.store_inventory[room_name]
		Global.score -= purchasePrice
		update_store(room_name)
		update_inventory(room_name)

func update_store(room_name):
	%StoreInventory.get_node(room_name).queue_free()
	Global.store_inventory.erase(room_name)
	
#func update_inventory():
	#for room in Global.available_rooms.keys():
		#var room_to_add = Global.available_rooms[room]
		#for i in Global.available_rooms.size():
			#var current_inventory_slot = %RoomInventory.get_child(i)
			#if current_inventory_slot.get_child_count() == 0:
				#current_inventory_slot.add_child(room_to_add)
				
func update_inventory(room):
		var room_to_add = Global.available_rooms[room]
		for i in Global.available_rooms.size():
			var current_inventory_slot = %RoomInventory.get_child(i)
			if current_inventory_slot.get_child_count() == 0:
				current_inventory_slot.add_child(room_to_add)
				current_inventory_slot.name = room_to_add.room_name
				EventBus.successful_purchase.emit(room_to_add)
				#current_inventory_slot.addLabel(room_to_add)
			
