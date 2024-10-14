class_name RoomInventory
extends PanelContainer

func init(cms: Vector2) -> void:
	custom_minimum_size = cms

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is RoomItem:
		if get_child_count() == 0:
			return true
	return false
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	#idk that this code can ever run but it was in the drag and drop tutorial
	if get_child_count() > 0:
		var item := get_child(0)
		if item == data:
			return
		item.reparent(data.get_parent())
		
	
	if !Global.available_rooms.has(data):
		Global.current_rooms.erase(data)
		Global.available_rooms.append(data)
	data.reparent(self)
	add_label(data)
	
func add_label(data: Variant):
	if data is RoomItem:
		var data_label = Label.new()
		data_label.text = data.room_name
		data.add_child(data_label)
