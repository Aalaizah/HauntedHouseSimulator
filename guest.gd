extends RigidBody2D
var speed = 50
var favorite_room

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = randf_range(100, 200)
