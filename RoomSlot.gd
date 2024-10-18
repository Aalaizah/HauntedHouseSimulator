class_name RoomSlot
extends PanelContainer

@export var room_size: RoomData.Room_Size

func init(rs: RoomData.Room_Size, cms: Vector2) -> void:
	room_size = rs
	custom_minimum_size = cms

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is RoomItem:
		if get_child_count() == 0:
			return true
	return false
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if get_child_count() > 0:
		var item := get_child(0)
		if item == data:
			return
		item.reparent(data.get_parent())
	if !Global.current_rooms.has(data):
		Global.available_rooms.erase(data.name)
		Global.current_rooms[data.name] = data
	data.reparent(self)
	if data.get_child_count() > 0:
		for child in data.get_children():
			child.queue_free()
