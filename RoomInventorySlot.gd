class_name RoomInventory
extends PanelContainer

func init(cms: Vector2) -> void:
	custom_minimum_size = cms
	EventBus.successful_purchase.connect(add_label)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is RoomItem:
		if get_child_count() == 0:
			return true
	return false
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	#idk that this code can ever run but it was in the drag and drop tutorial
	if get_child_count() > 0:
		var item := get_child(1)
		if item == data:
			return
		var current_parent = data.get_parent()
		item.reparent(current_parent)
		
	if data.data.room_size != 0:
		EventBus.large_room_removed.emit(data)
		data.in_house = false
	
	if !Global.inventory_rooms.has(data):
		Global.current_rooms.erase(data.name)
		Global.inventory_rooms[data.name] = data
	data.texture = data.data.icon
	self.name = data.name
	data.reparent(self)
	add_label(data)
	
func add_label(data: Variant):
	if data is RoomItem and data.get_child_count() == 0:
		var data_label = Label.new()
		data_label.text = data.room_name
		data_label.global_position.x = Global.icon_size + 10
		data_label.global_position.y = 10
		data.add_child(data_label)
