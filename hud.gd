extends CanvasLayer

var HouseSize = 6
var roomsLoad = [
	"res://Rooms(Resources)/Clown.tres",
	"res://Rooms(Resources)/Swamp.tres"
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in HouseSize:
		var slot := RoomSlot.new()
		slot.init(RoomData.Room_Size.SMALL, Vector2(200, 200))
		%HouseGrid.add_child(slot)
	for i in roomsLoad.size():
		var item := RoomItem.new()
		item.init(load(roomsLoad[i]))
		%HouseGrid.get_child(i).add_child(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
