extends ColorRect

@export var box_x = size.x / 2
@export var box_y = size.y / 2

signal turnchanged(isyourturn)
@export var yourturn = true:
	set(value):
		yourturn = value
		if yourturn:
			start_your_turn()
		else:
			start_enemy_turn()
		turnchanged.emit(yourturn)
@export var turns = 1



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
	pass
func start_your_turn():
	var data = $"../CanvasLayer/testicina".turn_data[turns - 1]
	self.hide()
	$"../soul".hide()
	self.position.x = -size.x / 2
	self.position.y = -size.y / 2
	var t = create_tween()
	t.parallel().tween_property($"../Background/ColorRect", "modulate:a", 0.0, 0.5)
	await get_tree().create_timer(data["transition_time"]).timeout
	self.yourturn = false
	
func start_enemy_turn():
	var data = $"../CanvasLayer/testicina".turn_data[turns - 1]
	# 1. Prepare the board
	self.show()
	$"../soul".show()
	$"../soul".position = Vector2(0, 0) # Center soul
	
	# 2. Animate board expansion
	var t = create_tween()
	t.parallel().tween_method(resize_board, size, data["board_size"], 0.5)
	t.parallel().tween_property(self, "position", -data["board_size"] / 2, 0.5)
	t.parallel().tween_property($"../Background/ColorRect", "modulate:a", 0.5, 0.5)
	
	# 3. Wait for the 'enemy_turn_length' 
	await get_tree().create_timer(data["enemy_turn_length"]).timeout
	
	# 4. Increment turn and go back to Player Turn
	if turns < $"../CanvasLayer/testicina".turn_data.size():
		turns += 1
		self.yourturn = true
	else:
		print("Battle Ended!")
	
func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, false, 2.0)

func resize_board(new_size: Vector2):
	# 1. Update the visual size and position
	size = new_size
	position = -new_size / 2
	
	# 2. Update the collisions immediately
	update_collision()
	
	# 3. Redraw the white outline
	queue_redraw()
	update_collision()

func update_collision():
	$collision/upcoll.shape.size = Vector2(size.x, 2)
	$collision/upcoll.position = Vector2(size.x / 2, size.y - size.y - 1)
	
	$collision/downcoll.shape.size = Vector2(size.x, 2)
	$collision/downcoll.position = Vector2(size.x / 2, size.y + 1)
	
	$collision/rightcoll.shape.size = Vector2(2, size.y)
	$collision/rightcoll.position = Vector2(size.x + 1, size.y / 2)
	
	$collision/leftcoll.shape.size = Vector2(2, size.y)
	$collision/leftcoll.position = Vector2(size.x - size.x - 1, size.y / 2)
