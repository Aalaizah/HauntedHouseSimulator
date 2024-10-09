extends Area2D
@export var size: Vector2
@export var room_scene: PackedScene
var rooms_list = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#add_room(Vector2(1,1), "forest")
	#add_room(Vector2(0,0), "swamp")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_room(location, room_name, color):
	#todo refactor for testing if the room fits
	var room_to_add = room_scene.instantiate()
	room_to_add.room_name = room_name
	room_to_add.room_size = Vector2(1,1)
	room_to_add.modulate = color
	var room_height = (location.y + .5) * Global.small_room_size
	var room_width = (location.x + .5) * Global.small_room_size
	room_to_add.position = Vector2(room_width, room_height)
	rooms_list[location] = room_to_add
	add_child(room_to_add)
