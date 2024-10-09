extends Area2D
var room_size: Vector2
var room_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("RoomName").text = room_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
