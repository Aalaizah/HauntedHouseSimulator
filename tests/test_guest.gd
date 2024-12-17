extends GutTest

var myGuestScene = load("res://guest.tscn")
var testGuest
var myGuestNode
var testRoom = load("res://Rooms(Resources)/Small Rooms/Resources/Clown.tres")

func before_each():
	myGuestNode = autofree(myGuestScene.instantiate())

func test_favorite_room_gets_set():
	var testRoomItem = RoomItem.new()
	testRoomItem.init(testRoom)
	Global.all_rooms[testRoom.room_name] = testRoomItem
	myGuestNode.get_room()
	assert_not_null(myGuestNode.favorite_room)
	
func test_animation_starts():
	myGuestNode.get_random_anim()
	var animatedSprite = myGuestNode.get_child(0)
	assert_true(animatedSprite.is_playing())
	
func test_guest_exit_adds_to_score():
	Global.score = 0
	var testRoomItem = RoomItem.new()
	testRoomItem.init(testRoom)
	Global.current_rooms[testRoom.room_name] = testRoomItem
	myGuestNode.favorite_room = testRoomItem.room_name
	myGuestNode.guest_exited_house(Global.maxTip)
	assert_gt(Global.score, 0)

func test_favorite_room_increases_tip():
	Global.score = 0
	var testRoomItem = RoomItem.new()
	testRoomItem.init(testRoom)
	Global.current_rooms[testRoom.room_name] = testRoomItem
	myGuestNode.favorite_room = testRoomItem.room_name
	myGuestNode.guest_exited_house(1)
	assert_gt(Global.score, 1)
