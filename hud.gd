extends ColorRect

var menuintween: Tween

func _ready() -> void:
	open_menu()
	$flavortext.visible_ratio = 0
	$"../../board".turnchanged.connect(_on_board_turn_changed)

func _on_board_turn_changed(yourturn):
	if $"../../board".yourturn:
		open_menu()
	else:
		close_menu()

func open_menu():
	var data = $"../testicina".turn_data[$"../../board".turns - 1]
	if menuintween:
		menuintween.kill()
	
	menuintween = create_tween()	
	
	$flavortext.text = data["flavor"]
	menuintween.tween_property(self, "position", Vector2(4, 96), 0.5).set_trans(Tween.TRANS_LINEAR)
	menuintween.tween_property($fight, "position", Vector2(self.position.x, 96 - $fight.size.y), 0.5).set_trans(Tween.TRANS_LINEAR)
	menuintween.tween_property($special, "position", Vector2(self.position.x + 91, 96 - $special.size.y), 0.5).set_trans(Tween.TRANS_LINEAR)
	menuintween.tween_property($maneuver, "position", Vector2(self.position.x + 183, 96 - $maneuver.size.y), 0.5).set_trans(Tween.TRANS_LINEAR)
	menuintween.tween_property($defend, "position", Vector2(self.position.x + 276, 96 - $defend.size.y), 0.5).set_trans(Tween.TRANS_LINEAR)
	var type_speed = 0.05 # Seconds per character
	var duration = $flavortext.text.length() * type_speed
	menuintween.parallel().tween_property($flavortext, "visible_ratio", 1, 1).set_trans(Tween.TRANS_LINEAR)

func close_menu():
	if menuintween:
		menuintween.kill()
		
	var menuouttween = create_tween()
		
	menuouttween.tween_property(self, "position", Vector2(4, size.y * 2), 0.5)
	$flavortext.visible_ratio = 0
	

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, false, 2.0)
	
	
	
