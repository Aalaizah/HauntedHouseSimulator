class_name HouseUpgradeItem
extends TextureRect

@export var data: HouseData
var house_name: String
var current_loc: Vector2
var in_house: bool = false

func init(d: HouseData) -> void:
	data = d
	house_name = data.name
	
func _ready():
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	texture = data.texture
	tooltip_text = "%s\n%s" % [data.name, data.description]
