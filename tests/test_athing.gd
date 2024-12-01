extends GutTest

#arrange, act, assert

func test_passes():
	assert_eq(1, 1)
	
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

#func test_hud_test():
	#var myHud = autofree(myHudObject.new())
	#assert_true(myHud.test_gut(2, 1))
	
#func test_gut(num1, num2) -> bool:
	#if num1 > num2:
		#return true
	#return false
