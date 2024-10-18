class_name BuyButton
extends Button
var data : RoomData

func init(d: RoomData):
	data = d

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Buy"
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	EventBus.room_bought.emit(data.room_name)
