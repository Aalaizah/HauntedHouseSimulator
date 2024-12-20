extends GutTest

var testRoomSlotScript = load("res://RoomInventorySlot.gd")
var testRoomSmall = load("res://Rooms(Resources)/Small Rooms/Resources/Clown.tres")
var testRoomMedLong = load("res://Rooms(Resources)/Medium Rooms/Resources/Swamp.tres")
var testRoomMedTall = load("res://Rooms(Resources)/Medium Rooms/Resources/Cemetery.tres")
var testRoomLarge = load("res://Rooms(Resources)/LargeRooms/Resources/Ocean.tres")
var testRoomSlot
var roomSize = Vector2(Global.small_room_size, Global.small_room_size)
var canDropData : bool
var testRoom
var testParentNode

func before_each():
	testRoomSlot = testRoomSlotScript.new()
	testRoomSlot.init(roomSize)
	testParentNode = testRoomSlotScript.new()
	testParentNode.init(roomSize)
	watch_signals(EventBus)
	
func after_each():
	Global.inventory_rooms.clear()
	
func test_can_drop_data():
	testRoom = RoomItem.new()
	testRoom.init(testRoomSmall)
	canDropData = testRoomSlot._can_drop_data(roomSize, testRoom)
	assert_true(canDropData)
	
func test_cant_drop_data():
	canDropData = testRoomSlot._can_drop_data(roomSize, testRoomSmall)
	assert_false(canDropData)
	
func test_drop_data_succeeds():
	testRoom = RoomItem.new()
	testRoom.init(testRoomSmall)
	testParentNode.add_child(testRoom)
	testRoomSlot._drop_data(roomSize, testRoom)
	assert_same(testRoom.get_parent(), testRoomSlot)
	
func test_drop_data_small_room_doesnt_emit_signal():
	testRoom = RoomItem.new()
	testRoom.init(testRoomSmall)
	testParentNode.add_child(testRoom)
	testRoomSlot._drop_data(roomSize, testRoom)
	assert_signal_not_emitted(EventBus, 'large_room_removed')
	
func test_drop_data_med_long_room_emits_signal():
	testRoom = RoomItem.new()
	testRoom.init(testRoomMedLong)
	testParentNode.add_child(testRoom)
	testRoomSlot._drop_data(roomSize, testRoom)
	assert_signal_emit_count(EventBus, 'large_room_removed', 1)
	
func test_drop_data_med_tall_room_emits_signal():
	testRoom = RoomItem.new()
	testRoom.init(testRoomMedTall)
	testParentNode.add_child(testRoom)
	testRoomSlot._drop_data(roomSize, testRoom)
	assert_signal_emit_count(EventBus, 'large_room_removed', 1)
	
func test_drop_data_large_room_emits_signal():
	testRoom = RoomItem.new()
	testRoom.init(testRoomLarge)
	testParentNode.add_child(testRoom)
	testRoomSlot._drop_data(roomSize, testRoom)
	assert_signal_emit_count(EventBus, 'large_room_removed', 1)
	
func test_add_label_adds_label():
	testRoom = RoomItem.new()
	testRoom.init(testRoomSmall)
	testParentNode.add_child(testRoom)
	testRoomSlot._drop_data(roomSize, testRoom)
	assert_eq(testRoom.get_child_count(), 1)
	
func test_room_is_added_to_inventory():
	testRoom = RoomItem.new()
	testRoom.init(testRoomSmall)
	testParentNode.add_child(testRoom)
	testRoomSlot._drop_data(roomSize, testRoom)
	assert_eq(Global.inventory_rooms.size(), 1)
	
func test_room_is_removed_from_house():
	testRoom = RoomItem.new()
	testRoom.init(testRoomSmall)
	testRoom.name = testRoom.room_name
	Global.current_rooms[testRoom.name] = testRoom
	testParentNode.add_child(testRoom)
	testRoomSlot._drop_data(roomSize, testRoom)
	assert_eq(Global.current_rooms.size(), 0)
