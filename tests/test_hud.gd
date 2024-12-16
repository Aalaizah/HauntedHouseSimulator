extends GutTest

class Test_House_Upgrade:
	extends GutTest
	var myHudScene = load("res://hud.tscn")
	var testHud
	var myHudNode
	var testHouse

	func before_each():
		testHud = double(myHudScene)
		myHudNode = autofree(testHud.instantiate().get_child(0))
		myHudNode.load_house_upgrades()
		myHudNode.setup_house_store()
		testHouse = load("res://Houses(Resources)/MediumHouse.tres")
		
	func test_house_purchase_upgrade_enough_money():
		Global.score = testHouse.price
		myHudNode.house_upgraded(testHouse)
		assert_eq(0, Global.score)
		
	func test_house_upgrade_not_enough_money():
		Global.score = testHouse.price - 1
		myHudNode.house_upgraded(testHouse)
		assert_ne(0, Global.score)
		
	func test_house_upgrade_rooms_exist():
		assert_ne(testHouse.house_size, Global.house_size)
		myHudNode.house_upgraded(testHouse)
		assert_eq(testHouse.house_size, Global.house_size)

class Test_Room_Purchase:
	extends GutTest
	var myHudScene = load("res://hud.tscn")
	var testHud
	var myHudNode
	var testRoomSmall

	func before_each():
		myHudNode = autofree(myHudScene.instantiate().get_child(0))
		myHudNode.roomsLoad = ["res://Rooms(Resources)/Small Rooms/Resources/Clown.tres"]
		myHudNode.load_rooms()
		myHudNode.setup_room_store()
		testRoomSmall = load("res://Rooms(Resources)/Small Rooms/Resources/Clown.tres")

	
	func test_room_purchase_enough_money():
		Global.score = testRoomSmall.price
		myHudNode.add_room_to_player_inventory(testRoomSmall.room_name, testRoomSmall.price)
		assert_eq(Global.score, 0)
		
	func test_room_inventory_updates():
		assert_eq(Global.inventory_rooms.size(), 0)
		myHudNode.add_room_to_player_inventory(testRoomSmall.room_name, 0)
		assert_eq(Global.inventory_rooms.size(), 1)
		
class Test_Room_Install:
	func install_successful():
		pass
