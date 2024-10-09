extends RigidBody2D
var speed = 50
var favorite_room: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = randf_range(50, 200)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
