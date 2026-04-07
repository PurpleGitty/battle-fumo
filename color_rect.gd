extends ColorRect

var x_pos = self.position.x
var y_pos = self.position.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_collision()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		size.x = randi() % 128 + 1
		size.y = randi() % 128 + 1
		x_pos = size.x / -2
		y_pos = size.y / -2
	update_collision()
	
	
func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, false, 2.0)

func update_collision():
	pass
