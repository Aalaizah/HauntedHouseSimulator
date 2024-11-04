extends CanvasLayer

var HouseSize = Global.house_size
var roomsLoad = Global.rooms_load

func _ready() -> void:
	setup_house_grid()
	setup_house()
	setup_room_store()
		
	EventBus.room_bought.connect(add_room_to_player_inventory)
	EventBus.large_room_installed.connect(large_room_installed)
	EventBus.large_room_removed.connect(large_room_removed)
	
func setup_house_grid():
	var House_Width = Global.small_room_size * (Global.house_size / 2.0)
	var House_Height = Global.small_room_size * (Global.house_size / 3.0)
	%HouseGrid.size.x = House_Width
	%HouseGrid.size.y = House_Height
	
func setup_house():
	var houseLocX = 0
	var houseLocY = 0		
	for i in HouseSize:
		var slot := HouseSlot.new()
		slot.init(RoomData.Room_Size.SMALL, Vector2(200, 200))
		slot.slot_loc = Vector2(houseLocX, houseLocY)
		slot.name = str(slot.slot_loc)
		var columnsFrom0 = (Global.house_size / 2.0) - 1
		if i >= (columnsFrom0):
			houseLocX = i-columnsFrom0
			houseLocY = 1
		else:
			houseLocX += 1
		%HouseGrid.add_child(slot)
		
	for i in roomsLoad.size():
		var item := RoomItem.new()
		item.init(load(roomsLoad[i]))
		item.name = item.room_name
		Global.store_inventory[item.name] = item
		Global.all_rooms[item.name] = item
		
	%HouseGrid.hide()
	
func setup_room_store():
	for i in Global.store_inventory:
		var item = StoreItem.new()
		var panel = PanelContainer.new()
		item.init(Global.store_inventory[i].data)
		panel.add_child(item)
		panel.name = item.data.room_name
		%StoreInventory.add_child(panel)
	
func setup_house_store():
	pass
	
func add_inventory_slot():
	var inventorySlot := RoomInventory.new()
	inventorySlot.init(Vector2(200, 50))
	%RoomInventory.add_child(inventorySlot)

func add_room_to_player_inventory(room_name: String):
	var purchasePrice = Global.store_inventory[room_name].data.price
	if (Global.score > purchasePrice 
	and !Global.inventory_rooms.has(room_name)):
		Global.inventory_rooms[room_name] = Global.store_inventory[room_name]
		Global.score -= purchasePrice
		update_store(room_name)
		add_inventory_slot()
		update_inventory_after_purchase(room_name)

func update_store(room_name):
	%StoreInventory.get_node(room_name).queue_free()
	Global.store_inventory.erase(room_name)
				
func update_inventory_after_purchase(room):
		var room_to_add = Global.inventory_rooms[room]
		for i in Global.inventory_rooms.size():
			var current_inventory_slot = %RoomInventory.get_child(i)
			if current_inventory_slot.get_child_count() == 0:
				current_inventory_slot.add_child(room_to_add)
				current_inventory_slot.get_child(0).texture = room_to_add.data.icon
				current_inventory_slot.name = room_to_add.room_name
				EventBus.successful_purchase.emit(room_to_add)
				
func large_room_removed(room):
	match room.data.room_size:
		1:
			var slot_to_hide = room.current_loc
			slot_to_hide.x += 1
			%HouseGrid.get_node(str(slot_to_hide)).get_child(0).queue_free()
		2:
			var slot_to_hide = room.current_loc
			slot_to_hide.y += 1
			%HouseGrid.get_node(str(slot_to_hide)).get_child(0).queue_free()
		3:
			var slot_to_hide = room.current_loc
			slot_to_hide.x += 1
			%HouseGrid.get_node(str(slot_to_hide)).get_child(0).queue_free()
			slot_to_hide.y += 1
			%HouseGrid.get_node(str(slot_to_hide)).get_child(0).queue_free()
			slot_to_hide.x -= 1
			%HouseGrid.get_node(str(slot_to_hide)).get_child(0).queue_free()
			
				
func large_room_installed(room, slot):
	match room.data.room_size:
		1:
			room.in_house = true
			room.current_loc = slot
			var panel = TextureRect.new()
			var room_part_1 = room.data.atlasTexture.duplicate()
			var room_part_2 = room_part_1.duplicate()
			room_part_1.region = Rect2(Vector2(0, 0), Vector2(200, 200))
			room_part_2.region = Rect2(Vector2(200, 0), Vector2(200, 200))
			%HouseGrid.get_node(str(slot)).get_child(0).texture = room_part_1
			slot.x += 1
			var slot_to_hide = %HouseGrid.get_node(str(slot))
			Global.hidden_slots[slot_to_hide.name] = slot_to_hide
			panel.texture = room_part_2
			slot_to_hide.add_child(panel)
		2:
			room.in_house = true
			room.current_loc = slot
			var panel = TextureRect.new()
			var room_part_1 = room.data.atlasTexture.duplicate()
			var room_part_2 = room_part_1.duplicate()
			room_part_1.region = Rect2(Vector2(0, 0), Vector2(200, 200))
			room_part_2.region = Rect2(Vector2(0, 200), Vector2(200, 200))
			%HouseGrid.get_node(str(slot)).get_child(0).texture = room_part_1
			slot.y += 1
			var slot_to_hide = %HouseGrid.get_node(str(slot))
			Global.hidden_slots[slot_to_hide.name] = slot_to_hide
			panel.texture = room_part_2
			slot_to_hide.add_child(panel)
		3:
			room.in_house = true
			room.current_loc = slot
			var panel1 = TextureRect.new()
			var panel2 = TextureRect.new()
			var panel3 = TextureRect.new()
			var room_part_1 = room.data.atlasTexture.duplicate()
			var room_part_2 = room_part_1.duplicate()
			var room_part_3 = room_part_1.duplicate()
			var room_part_4 = room_part_1.duplicate()
			room_part_1.region = Rect2(Vector2(0, 0), Vector2(200, 200)) # Top Left
			room_part_2.region = Rect2(Vector2(0, 200), Vector2(200, 200)) # Bottom Left
			room_part_3.region = Rect2(Vector2(200, 0), Vector2(200, 200)) # Top Right
			room_part_4.region = Rect2(Vector2(200, 200), Vector2(200, 200)) # Bottom Right
			%HouseGrid.get_node(str(slot)).get_child(0).texture = room_part_1
			slot.x += 1
			var slot_to_hide = %HouseGrid.get_node(str(slot))
			Global.hidden_slots[slot_to_hide.name] = slot_to_hide
			panel1.texture = room_part_3
			slot_to_hide.add_child(panel1)
			slot.y += 1
			slot_to_hide = %HouseGrid.get_node(str(slot))
			Global.hidden_slots[slot_to_hide.name] = slot_to_hide
			panel2.texture = room_part_4
			slot_to_hide.add_child(panel2)
			slot.x -= 1
			slot_to_hide = %HouseGrid.get_node(str(slot))
			Global.hidden_slots[slot_to_hide.name] = slot_to_hide
			panel3.texture = room_part_2
			slot_to_hide.add_child(panel3)
