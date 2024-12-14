class_name RoomItem
extends TextureRect

var data: RoomData
var room_name: String
var current_loc: Vector2
var in_house: bool = false

func init(d: RoomData) -> void:
	data = d
	room_name = data.room_name
	
func _ready():
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	texture = data.textureArt
	tooltip_text = "%s\n%s" % [data.room_name, data.description]
	
func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(make_drag_preview(at_position))
	return self
	
func make_drag_preview(at_position: Vector2):
	var t:= TextureRect.new()
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.custom_minimum_size = Vector2(100, 100)
	t.modulate.a = 0.5
	t.position = Vector2(-at_position)
	t.texture = data.textureArt
	
	var c:= Control.new()
	c.add_child(t)
	
	return c
