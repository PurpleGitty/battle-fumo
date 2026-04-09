extends ColorRect

var menuintween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open_menu()
	$flavortext.visible_ratio = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"../../ColorRect".yourturn:
		open_menu()
	else:
		close_menu()

func open_menu():
	if menuintween:
		menuintween.kill()
	
	menuintween = create_tween()	
	
	
	menuintween.tween_property(self, "position", Vector2(4, 96), 0.5)
	menuintween.parallel().tween_property($flavortext, "visible_ratio", 1, 1)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN)

func close_menu():
	if menuintween:
		menuintween.kill()
		
	var menuouttween = create_tween()
		
	menuouttween.tween_property(self, "position", Vector2(4, size.y * 2), 0.5)
	$flavortext.visible_ratio = 0
	

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, false, 2.0)
