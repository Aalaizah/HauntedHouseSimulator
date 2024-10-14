class_name HouseData
extends Resource

enum House_Size {SMALL = 6, MEDIUM = 10, LARGE = 20}

@export var house_size : House_Size
@export var name: String
@export_multiline var description: String
@export var texture: Texture2D
