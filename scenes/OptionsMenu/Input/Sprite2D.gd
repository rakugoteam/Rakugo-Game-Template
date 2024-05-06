extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	position = position.move_toward(position + dir, 10)
	
	pass
