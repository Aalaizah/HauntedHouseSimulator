extends GutTest

var testHouseSlotScript = load("res://HouseSlot.gd")
var testRoomSmall = load("res://Rooms(Resources)/Small Rooms/Resources/Clown.tres")
var testRoomMedLong = load("res://Rooms(Resources)/Medium Rooms/Resources/Swamp.tres")
var testRoomMedTall = load("res://Rooms(Resources)/Medium Rooms/Resources/Cemetery.tres")
var testRoomLarge = load("res://Rooms(Resources)/LargeRooms/Resources/Ocean.tres")
var testHouseSlot
var roomSize = Vector2(Global.small_room_size, Global.small_room_size)
var canDropData : bool
var testRoom
var testParentNode

func before_each():
	testHouseSlot = testHouseSlotScript.new()
	testHouseSlot.init(testRoomSmall.room_size, roomSize)
	testParentNode = testHouseSlotScript.new()
	testParentNode.init(testRoomSmall.room_size, roomSize)
	
func after_each():
	Global.current_rooms.clear()
	
func test_can_drop_data_when_can_small():
	testRoom = RoomItem.new()
	testRoom.init(testRoomSmall)
	canDropData = testHouseSlot._can_drop_data(roomSize, testRoom)
	assert_true(canDropData)

func test_can_drop_data_when_cant_small():
	testRoom = RoomItem.new()
	testRoom.init(testRoomSmall)
	testHouseSlot.add_child(testRoom)
	canDropData = testHouseSlot._can_drop_data(roomSize, testRoom)
	assert_false(canDropData)
	
func test_can_drop_data_when_can_med_long():
	testRoom = RoomItem.new()
	testRoom.init(testRoomMedLong)
	canDropData = testHouseSlot._can_drop_data(roomSize, testRoom)
	assert_true(canDropData)

func test_can_drop_data_when_cant_med_long():
	testRoom = RoomItem.new()
	testRoom.init(testRoomMedLong)
	testHouseSlot.add_child(testRoom)
	canDropData = testHouseSlot._can_drop_data(roomSize, testRoom)
	assert_false(canDropData)
	
func test_can_drop_data_when_can_med_tall():
	testRoom = RoomItem.new()
	testRoom.init(testRoomMedTall)
	canDropData = testHouseSlot._can_drop_data(roomSize, testRoom)
	assert_true(canDropData)

func test_can_drop_data_when_cant_med_tall():
	testRoom = RoomItem.new()
	testRoom.init(testRoomMedTall)
	testHouseSlot.add_child(testRoom)
	canDropData = testHouseSlot._can_drop_data(roomSize, testRoom)
	assert_false(canDropData)
	
func test_can_drop_data_when_can_large():
	testRoom = RoomItem.new()
	testRoom.init(testRoomLarge)
	canDropData = testHouseSlot._can_drop_data(roomSize, testRoom)
	assert_true(canDropData)

func test_cant_drop_data_when_cant_large():
	testRoom = RoomItem.new()
	testRoom.init(testRoomLarge)
	testHouseSlot.add_child(testRoom)
	canDropData = testHouseSlot._can_drop_data(roomSize, testRoom)
	assert_false(canDropData)
	
func test_cant_drop_non_room_data():
	canDropData = testHouseSlot._can_drop_data(roomSize, testRoomSmall)
	assert_false(canDropData)
	
func test_drop_data_small():
	testRoom = RoomItem.new()
	testRoom.init(testRoomSmall)
	testParentNode.add_child(testRoom)
	testHouseSlot._drop_data(roomSize, testRoom)
	assert_same(testRoom.get_parent(), testHouseSlot)
	
func test_drop_data_med_long():
	testRoom = RoomItem.new()
	testRoom.init(testRoomMedLong)
	testParentNode.add_child(testRoom)
	testHouseSlot._drop_data(roomSize, testRoom)
	assert_same(testRoom.get_parent(), testHouseSlot)
	
func test_drop_data_med_tall():
	testRoom = RoomItem.new()
	testRoom.init(testRoomMedTall)
	testParentNode.add_child(testRoom)
	testHouseSlot._drop_data(roomSize, testRoom)
	assert_same(testRoom.get_parent(), testHouseSlot)
	
func test_drop_data_large():
	testRoom = RoomItem.new()
	testRoom.init(testRoomLarge)
	testParentNode.add_child(testRoom)
	testHouseSlot._drop_data(roomSize, testRoom)
	assert_same(testRoom.get_parent(), testHouseSlot)

func test_room_added_to_house_dictionary():
	testRoom = RoomItem.new()
	testRoom.init(testRoomSmall)
	testParentNode.add_child(testRoom)
	testHouseSlot._drop_data(roomSize, testRoom)
	assert_eq(Global.current_rooms.size(), 1)
	
func test_room_removed_from_inventory():
	testRoom = RoomItem.new()
	testRoom.init(testRoomSmall)
	testRoom.name = testRoom.room_name
	Global.inventory_rooms[testRoom.name] = testRoom
	testParentNode.add_child(testRoom)
	testHouseSlot._drop_data(roomSize, testRoom)
	assert_eq(Global.inventory_rooms.size(), 0)
	
func test_large_room_removed_emits_if_in_house():
	watch_signals(EventBus)
	testRoom = RoomItem.new()
	testRoom.init(testRoomLarge)
	testRoom.name = testRoom.room_name
	testRoom.in_house = true
	testParentNode.add_child(testRoom)
	testHouseSlot._drop_data(roomSize, testRoom)
	assert_signal_emit_count(EventBus, "large_room_removed", 1)
	
func test_large_room_removed_doesnt_emit_if_not_in_house():
	watch_signals(EventBus)
	testRoom = RoomItem.new()
	testRoom.init(testRoomLarge)
	testRoom.name = testRoom.room_name
	testParentNode.add_child(testRoom)
	testHouseSlot._drop_data(roomSize, testRoom)
	assert_signal_not_emitted(EventBus, "large_room_removed")
	
func test_large_room_installed_emits():
	watch_signals(EventBus)
	testRoom = RoomItem.new()
	testRoom.init(testRoomLarge)
	testRoom.name = testRoom.room_name
	testParentNode.add_child(testRoom)
	testHouseSlot._drop_data(roomSize, testRoom)
	assert_signal_emit_count(EventBus, "large_room_installed", 1)
	
func test_small_room_doesnt_emit_large_room_installed():
	watch_signals(EventBus)
	testRoom = RoomItem.new()
	testRoom.init(testRoomSmall)
	testRoom.name = testRoom.room_name
	testParentNode.add_child(testRoom)
	testHouseSlot._drop_data(roomSize, testRoom)
	assert_signal_not_emitted(EventBus, "large_room_installed")
