class_name RoomData
extends Resource

enum Room_Size {SMALL, MEDIUM_LONG, MEDIUM_TALL, LARGE}

@export var room_size : Room_Size
@export var room_name: String
@export_multiline var description: String
@export var texture: Texture2D
@export var atlasTexture: AtlasTexture
@export var icon: Texture2D
@export var price: int
