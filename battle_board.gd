extends ColorRect

@export var box_x = size.x / 2
@export var box_y = size.y / 2
@export var yourturn = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = Vector2(64, 64)
	position = Vector2(-32, -32)
	yourturn = true
	update_collision()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var boardtween = create_tween()
	if Input.is_action_just_pressed("ui_accept"):
		if yourturn == true:
			self.show()
			$"../soul".show()
			$"../soul".position = Vector2(0, 0)
			boardtween.tween_property(self, "size", Vector2(randi() % 128 + 64, randi() % 128 + 64), 0.5)
			boardtween.parallel().tween_property(self, "position", Vector2(-size.x, -size.y), 0.5)
			self.position.x = -size.x / 2
			self.position.y = -size.y / 2
			yourturn = false
		else:
			self.hide()
			size = Vector2(64, 64)
			position = Vector2(-32, -32)
			$"../soul".hide()
			yourturn = true
	update_collision()
	
	
func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, false, 2.0)

func update_collision():
	$collision/upcoll.shape.size = Vector2(size.x, 2)
	$collision/upcoll.position = Vector2(size.x / 2, size.y - size.y - 1)
	
	$collision/downcoll.shape.size = Vector2(size.x, 2)
	$collision/downcoll.position = Vector2(size.x / 2, size.y + 1)
	
	$collision/rightcoll.shape.size = Vector2(2, size.y)
	$collision/rightcoll.position = Vector2(size.x + 1, size.y / 2)
	
	$collision/leftcoll.shape.size = Vector2(2, size.y)
	$collision/leftcoll.position = Vector2(size.x - size.x - 1, size.y / 2)
