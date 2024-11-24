class_name HouseSlot
extends PanelContainer

@export var room_size: RoomData.Room_Size
var slot_loc: Vector2

func init(rs: RoomData.Room_Size, cms: Vector2) -> void:
	room_size = rs
	custom_minimum_size = cms
	
func _ready():
	pass

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is RoomItem:
		if get_child_count() == 0:
			match data.data.room_size:
				0:
					return true
				1:
					if slot_loc.x == (Global.house_size / 2.0) - 1:
						return false
				2:
					if slot_loc.y > 0:
						return false
				3:
					if slot_loc.y > 0 or slot_loc.x > 1:
						return false
			return true
	return false
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if get_child_count() > 0:
		var item := get_child(0)
		if item == data:
			return
		item.reparent(data.get_parent())
	if !Global.current_rooms.has(data):
		Global.inventory_rooms.erase(data.name)
		Global.current_rooms[data.name] = data
	data.texture = data.data.textureArt
	data.reparent(self)
	if data.data.room_size != 0:
		if data.in_house == true:
			EventBus.large_room_removed.emit(data)
		EventBus.large_room_installed.emit(data, self.slot_loc)
	if data.get_child_count() > 0:
		for child in data.get_children():
			child.queue_free()
