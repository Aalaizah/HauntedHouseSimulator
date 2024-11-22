class_name BuyButton
extends Button
var data

func init(d):
	data = d

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Buy"
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	if data is RoomData and (Global.score > data.price):
		EventBus.room_bought.emit(data.room_name, data.price)
	elif data is HouseData and (Global.score > data.price):
		EventBus.house_bought.emit(data)
