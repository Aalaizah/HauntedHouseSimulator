extends GutTest

var testBuyButton = load("res://BuyButton.gd")
var doubledBuyButton

func before_each():
	doubledBuyButton = autofree(testBuyButton.new())

func test_room_emits():
	var testRoomSmall = load("res://Rooms(Resources)/Small Rooms/Resources/Clown.tres")
	doubledBuyButton.init(testRoomSmall)
	Global.score = testRoomSmall.price
	watch_signals(EventBus)
	doubledBuyButton._on_button_pressed()
	assert_signal_emit_count(EventBus, 'room_bought', 1)
	
func test_house_emits():
	var testHouse = load("res://Houses(Resources)/MediumHouse.tres")
	doubledBuyButton.init(testHouse)
	Global.score = testHouse.price
	watch_signals(EventBus)
	doubledBuyButton._on_button_pressed()
	assert_signal_emit_count(EventBus, 'house_bought', 1)
