class_name RoomSlot
extends PanelContainer

@export var room_size: RoomData.Room_Size

func init(rs: RoomData.Room_Size, cms: Vector2) -> void:
	room_size = rs
	custom_minimum_size = cms
