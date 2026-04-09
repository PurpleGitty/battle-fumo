extends ColorRect

@export var box_x = size.x / 2
@export var box_y = size.y / 2
@export var yourturn = true
@export var debug = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = Vector2(64, 64)
	position = Vector2(-32, -32)
	yourturn = true
	$"../Background/ColorRect".show()
	$"../Background/ColorRect".modulate.a = 0
	update_collision()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DEBUG"):
		if debug:
			if Input.is_action_pressed("D_BOARD_X+"):
				size.x += 1
			if Input.is_action_pressed("D_BOARD_X-"):
				size.x -= 1
			if Input.is_action_pressed("D_BOARD_Y+"):
				size.y += 1
			if Input.is_action_pressed("D_BOARD_Y-"):
				size.y -= 1
			debug = false
			$"../CanvasLayer/debug menu".hide()
		else:
			debug = true
			$"../CanvasLayer/debug menu".show()
	var boardtweenon = create_tween()
	var boardtweenoff = create_tween()
	if Input.is_action_just_pressed("ui_accept"):
		if yourturn == true:
			self.show()
			$"../soul".show()
			$"../soul".position = Vector2(0, 0)
			self.position.x = -size.x / 2
			self.position.y = -size.y / 2
			boardtweenon.tween_property(self, "size", Vector2(128, 128), 0.5)
			boardtweenon.parallel().tween_property(self, "position", Vector2(-size.x, -size.y), 0.5)
			boardtweenon.parallel().tween_property($"../Background/ColorRect", "modulate:a", 0.5, 0.5)
			if size == Vector2(128, 128):
					boardtweenon.kill()
			yourturn = false
		else:
			self.hide()
			size = Vector2(64, 64)
			position = Vector2(-32, -32)
			boardtweenon.parallel().tween_property($"../Background/ColorRect", "modulate:a", 0, 0.5)
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
