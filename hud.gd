extends CanvasLayer

var roomsLoad = Global.rooms_load
var houseUpgradesLoad = Global.house_upgrades_load

func _ready() -> void:
	load_rooms()
	load_house_upgrades()
	setup_house_store()
	setup_house_grid()
	setup_room_store()
		
	EventBus.room_bought.connect(add_room_to_player_inventory)
	EventBus.update_inventory.connect(add_room_to_player_inventory)
	EventBus.large_room_installed.connect(large_room_installed)
	EventBus.large_room_removed.connect(large_room_removed)
	EventBus.house_bought.connect(house_upgraded)
	EventBus.load_house.connect(load_house)
	
func load_rooms():
	for i in roomsLoad.size():
		var item := RoomItem.new()
		item.init(load(roomsLoad[i]))
		item.name = item.room_name
		Global.store_inventory[item.name] = item
		Global.all_rooms[item.name] = item
	
func load_house_upgrades():
	for i in houseUpgradesLoad.size():
		var item := HouseUpgradeItem.new()
		item.init(load(houseUpgradesLoad[i]))
		Global.house_inventory[item.data.name] = item

func setup_house_grid():
	var House_Width = Global.small_room_size * (Global.house_size / 2.0)
	var House_Height = Global.small_room_size * (Global.house_size / 3.0)
	%HouseGrid.size.x = House_Width
	%HouseGrid.size.y = House_Height
	setup_house()
	
func clear_house():
	for slot in %HouseGrid.get_children():
		var has_room = slot.get_child_count()
		if has_room > 0:
			var room = slot.get_child(0)
			var inventory = get_node("RoomScroll/RoomInventory")
			for place in inventory.get_children():
				if place.get_child_count() == 0:
					if "data" in room:
						room.in_house = false
						room.texture = room.data.icon
						room.reparent(place)
						Global.inventory_rooms[room.name] = room
						Global.current_rooms.erase(room.name)
						place.add_label(room)
		%HouseGrid.remove_child(slot)
		slot.queue_free()
	
func setup_house():
	clear_house()
	var houseLocX = 0
	var houseLocY = 0
	var columnsFrom0 = (Global.house_size / 2.0) - 1
	%HouseGrid.columns = Global.current_house.data.house_columns
	for i in Global.house_size:
		var slot := HouseSlot.new()
		slot.init(RoomData.Room_Size.SMALL, Vector2(200, 200))
		slot.slot_loc = Vector2(houseLocX, houseLocY)
		slot.name = str(slot.slot_loc)
		if i >= (columnsFrom0):
			houseLocX = i-columnsFrom0
			houseLocY = 1
		else:
			houseLocX += 1
		%HouseGrid.add_child(slot)
		
	%HouseGrid.hide()
	
func save_house():
	var house = %HouseGrid.get_children()
	var house_data = {}
	for slot in house:
		if slot.get_child_count() > 0:
			house_data[slot.name] = slot.get_child(0).name
	return house_data

func load_house(house_data):
	setup_house()
	var house = get_node("HouseGrid").get_children()
	var inv = get_node("RoomScroll/RoomInventory").get_children()
	for room in house_data:
		for slot in house:
			if slot.name == room:
				for item in inv:
					if item.name == house_data[room]:
						if item.get_child(0).get_child_count() > 0:
							item.get_child(0).get_child(0).queue_free()
						var item_to_move = item.get_child(0)
						item.get_child(0).reparent(slot)
						large_room_installed(item_to_move, str_to_var("Vector2" + room))

func setup_room_store():
	for i in Global.store_inventory:
		var item = StoreItem.new()
		var panel = PanelContainer.new()
		item.init(Global.store_inventory[i].data)
		if(item.data is RoomData):
			panel.add_child(item)
			panel.name = item.data.room_name
			%StoreInventory.add_child(panel)
	
func setup_house_store():
	for i in Global.house_inventory:
		var item = StoreItem.new()
		var panel = PanelContainer.new()
		item.init(Global.house_inventory[i].data)
		if(item.data is HouseData):
			if(item.data.name == "Starter"):
				Global.current_house = item
				Global.house_size = Global.current_house.data.house_size
			else:
				panel.add_child(item)
				panel.name = item.data.name
				%HouseUpgradeInventory.add_child(panel)
	
func add_inventory_slot():
	var inventorySlot := RoomInventory.new()
	inventorySlot.init(Vector2(200, 50))
	%RoomInventory.add_child(inventorySlot)

func add_room_to_player_inventory(room_name: String, purchasePrice: int):
	if !Global.inventory_rooms.has(room_name) and Global.store_inventory.has(room_name):
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
	room.in_house = false
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
			room.current_loc = slot
			var panel = TextureRect.new()
			var room_part_1 = room.data.atlasTexture.duplicate()
			var room_part_2 = room_part_1.duplicate()
			room_part_1.region = Rect2(Vector2(0, 0), Vector2(200, 200))
			room_part_2.region = Rect2(Vector2(200, 0), Vector2(200, 200))
			%HouseGrid.get_node(str(slot)).get_child(0).texture = room_part_1
			slot.x += 1
			var slot_to_hide = %HouseGrid.get_node(str(slot))
			var panel_name = room.name
			panel.name = panel_name + "2"
			panel.texture = room_part_2
			slot_to_hide.add_child(panel)
		2:
			room.current_loc = slot
			var panel = TextureRect.new()
			var room_part_1 = room.data.atlasTexture.duplicate()
			var room_part_2 = room_part_1.duplicate()
			room_part_1.region = Rect2(Vector2(0, 0), Vector2(200, 200))
			room_part_2.region = Rect2(Vector2(0, 200), Vector2(200, 200))
			%HouseGrid.get_node(str(slot)).get_child(0).texture = room_part_1
			slot.y += 1
			var slot_to_hide = %HouseGrid.get_node(str(slot))
			var panel_name = room.name
			panel.name = panel_name + "2"
			panel.texture = room_part_2
			slot_to_hide.add_child(panel)
		3:
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
			var panel_name = room.name
			panel1.name = panel_name + "3"
			panel1.texture = room_part_3
			slot_to_hide.add_child(panel1)
			slot.y += 1
			slot_to_hide = %HouseGrid.get_node(str(slot))
			panel2.texture = room_part_4
			slot_to_hide.add_child(panel2)
			slot.x -= 1
			slot_to_hide = %HouseGrid.get_node(str(slot))
			panel3.texture = room_part_2
			slot_to_hide.add_child(panel3)
	room.in_house = true

func house_upgraded(house):
	Global.current_house = Global.house_inventory[house.name]
	Global.house_size = house.house_size
	Global.score -= house.price
	setup_house_grid()
	%HouseUpgradeInventory.get_node(house.name).queue_free()
	Global.house_inventory.erase(house.name)
