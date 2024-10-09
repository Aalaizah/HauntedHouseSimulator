class_name RoomData
extends Resource

enum Room_Size {SMALL, MEDIUM, LARGE}

@export var room_size : Room_Size
@export var name: String
@export_multiline var description: String
@export var texture: Texture2D
