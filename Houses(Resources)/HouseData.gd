class_name HouseData
extends Resource

enum House_Size {SMALL = 6, MEDIUM = 8, LARGE = 10, WAREHOUSE = 12, MANSION = 20}

@export var house_size : House_Size
@export var name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var price: int
@export var house_columns: int
