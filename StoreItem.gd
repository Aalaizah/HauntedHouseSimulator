class_name StoreItem
extends HBoxContainer
var data

func init(room):
	data = room


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var iconContainer = MarginContainer.new()
	var icon = TextureRect.new()
	icon.texture = data.icon
	iconContainer.add_child(icon)
	add_child(iconContainer)
	
	var item_name: String
	if data is RoomData:
		item_name = data.room_name
	elif data is HouseData:
		item_name = data.name
	
	var textContainer = MarginContainer.new()
	textContainer.custom_minimum_size = Vector2(400, 50)
	var textBoxContainer = VBoxContainer.new()
	var nameLabel = Label.new()
	var descriptionLabel = Label.new()
	var priceLabel = Label.new()
	nameLabel.text = item_name
	descriptionLabel.text = data.description
	priceLabel.text = str(data.price)
	textBoxContainer.add_child(nameLabel)
	textBoxContainer.add_child(descriptionLabel)
	textBoxContainer.add_child(priceLabel)
	textContainer.add_child(textBoxContainer)
	add_child(textContainer)
	
	var buttonContainer = MarginContainer.new()
	buttonContainer.name = "buttonContainer"
	var buyButton = BuyButton.new()
	buyButton.init(data)
	buyButton.name = "buyButton"
	buttonContainer.add_child(buyButton)
	add_child(buttonContainer)
