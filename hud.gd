extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"../../ColorRect".yourturn:
		open_menu()
	else:
		close_menu()

func open_menu():
	var menuintween = create_tween()
	menuintween.set_ease(Tween.EASE_IN)
	#menuintween.set_trans(Tween.TRANS_QUART)
	menuintween.tween_property(self, "position", Vector2(4, 96), 0.5)

func close_menu():
	var menuouttween = create_tween()
	menuouttween.tween_property(self, "position", Vector2(4, size.y * 2), 0.5)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, false, 2.0)
