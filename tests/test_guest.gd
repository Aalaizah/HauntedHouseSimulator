extends GutTest

var myGuestScene = load("res://guest.tscn")
var testGuest
var myGuestNode
var testRoom = load("res://Rooms(Resources)/Small Rooms/Resources/Clown.tres")

func before_each():
	testGuest = double(myGuestScene)
	myGuestNode = autofree(myGuestScene.instantiate())

func test_favorite_room_gets_set():
	pass
	
func test_random_animation():
	pass
	
func test_guest_exit_adds_to_score():
	Global.score = 0
	var testRoomItem = RoomItem.new()
	testRoomItem.init(testRoom)
	Global.current_rooms[testRoom.room_name] = testRoomItem
	myGuestNode.favorite_room = testRoomItem.room_name
	myGuestNode.guest_exited_house()
	assert_gt(Global.score, 0)
	pass
