extends ColorRect

var menuintween: Tween
var selected_tab = 0 # the tab currently hovered, NOT ENTERED
var tabs = []
var playermoves = 0 # tracks if one or both of the characters have chosen their moves. if both do, they finish up early and wait for the enemy's turn
var attacking = 0 # will update for each character who chose the basic attack, will determine how many times the basic attack minigame will play before the enemy's turn

@onready var purple_d = $"../purple".dead
@onready var violet_d = $"../violet".dead

# The different screen "states" the player can see
enum MenuState { TAB_SELECT, MOVE_SELECT, ENEMY_SELECT, DIALOGUE }
var current_state = MenuState.TAB_SELECT

# Track choices so we can undo them if the player presses BACK
var purple_choice = null # Stores Purple's picked move data
var violet_choice = null # Stores Violet's picked move data

# Sub-menu navigation variables
var selected_move_index = 0
var selected_enemy_index = 0

var purple_specials = [
	{"name": "Crucible", "cost": 15, "type": "timed_bar", "damage": 500},
	{"name": "Guitar", "cost": 70, "type": "rapid_tap", "damage": 1200}
]

var violet_specials = [
	{"name": "P90", "cost": 20, "type": "rapid_tap", "damage": 700},
	{"name": "AWP", "cost": 80, "type": "circle_shrink", "damage": 1600}
]

func _ready() -> void:
	open_menu()
	$flavortext.visible_ratio = 0
	$"../../board".turnchanged.connect(_on_board_turn_changed)
	tabs = [$fight, $special, $maneuver, $defend]
	update_tab_visuals()
	
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
	menuintween.tween_property($fight, "position", Vector2(0, -32), 0.1).set_trans(Tween.TRANS_LINEAR)
	menuintween.tween_property($special, "position", Vector2(91, -32), 0.1).set_trans(Tween.TRANS_LINEAR)
	menuintween.tween_property($maneuver, "position", Vector2(183, -32), 0.1).set_trans(Tween.TRANS_LINEAR)
	menuintween.tween_property($defend, "position", Vector2(276, -32), 0.1).set_trans(Tween.TRANS_LINEAR)
	var type_speed = 0.05 # Seconds per character
	var duration = $flavortext.text.length() * type_speed
	menuintween.parallel().tween_property($flavortext, "visible_ratio", 1, 1).set_trans(Tween.TRANS_LINEAR)
	
func close_menu():
	if menuintween:
		menuintween.kill()
		
	var menuouttween = create_tween()
		
	menuouttween.tween_property(self, "position", Vector2(4, size.y * 2), 0.5)
	# 1. Animate all tabs back down smoothly at the same time
	menuouttween.parallel().tween_property($fight, "position", Vector2(0, 32), 0.1).set_trans(Tween.TRANS_LINEAR)
	menuouttween.parallel().tween_property($special, "position", Vector2(91, 32), 0.1).set_trans(Tween.TRANS_LINEAR)
	menuouttween.parallel().tween_property($maneuver, "position", Vector2(183, 32), 0.1).set_trans(Tween.TRANS_LINEAR)
	menuouttween.parallel().tween_property($defend, "position", Vector2(276, 32), 0.1).set_trans(Tween.TRANS_LINEAR)
	
	# 2. Reset the text visibility ratio safely on its own line
	$flavortext.visible_ratio = 0
	
func _input(event: InputEvent) -> void:
	if not $"../../board".yourturn:
		return
	
	# --- 1. DEFINE WHOSE TURN IT IS TO INPUT ---
	var character_name = []
	if not purple_d and not violet_d:
		character_name = ["Purple", "Violet"]
	elif purple_d:
		character_name = ["Violet"]
	elif violet_d:
		character_name = ["Purple"]
		
	var current_choice = ""
	if character_name.size() == 2:
		current_choice = "Purple" if playermoves == 0 else "Violet"
	elif character_name.size() == 1:
		current_choice = character_name[0]

	# Handle visual indicators for active picker
	$mc1.self_modulate = Color.YELLOW if current_choice == "Purple" else Color.WHITE
	$mc2.self_modulate = Color.YELLOW if current_choice == "Violet" else Color.WHITE
	
	# --- 2. STATE HANDLERS ---
	match current_state:
		MenuState.TAB_SELECT:
			handle_tab_selection(event, current_choice)
			
		MenuState.MOVE_SELECT:
			handle_move_selection(event, current_choice)
			
		MenuState.ENEMY_SELECT:
			handle_enemy_selection(event, current_choice)
			
# --- 4. SEPARATED STATE LOGIC FUNCTIONS ---

func handle_tab_selection(event, current_choice):
	if event.is_action_pressed("ui_right"):
		selected_tab = min(selected_tab + 1, 3)
		update_tab_visuals()
	elif event.is_action_pressed("ui_left"):
		selected_tab = max(selected_tab - 1, 0)
		update_tab_visuals()
		
	if event.is_action_pressed("ACCEPT"):
		$"../../Select".play()
		if selected_tab == 0:   # Fight
			# Skip move select, go straight to enemy select for basic attack
			current_state = MenuState.ENEMY_SELECT
			show_enemy_selection()
		elif selected_tab == 1: # Special
			current_state = MenuState.MOVE_SELECT
			selected_move_index = 0
			show_special(current_choice)
			update_move_highlights(current_choice)
		# Add placeholders for tabs 2 and 3...

	# Can't press BACK at tab level unless you want to cancel the turn phase entirely

func handle_move_selection(event, current_choice):
	var moves = purple_specials if current_choice == "Purple" else violet_specials

	if event.is_action_pressed("ui_down"):
		selected_move_index = min(selected_move_index + 1, moves.size() - 1)
		update_move_highlights(current_choice)
	elif event.is_action_pressed("ui_up"):
		selected_move_index = max(selected_move_index - 1, 0)
		update_move_highlights(current_choice)

	elif event.is_action_pressed("ACCEPT"):
		$"../../Select".play()
		var picked_move = moves[selected_move_index]
		
		# Save choice to the active character slot
		if current_choice == "Purple":
			purple_choice = picked_move
		else:
			violet_choice = picked_move
			
		current_state = MenuState.ENEMY_SELECT
		show_enemy_selection()

	elif event.is_action_pressed("BACK"): # GOTO PREVIOUS STATE
		# Clear sub-menu elements and bring back flavor text
		$menucontent.hide()
		$flavortext.show()
		current_state = MenuState.TAB_SELECT

func update_move_highlights(current_choice):
	# Colorize the active menu label yellow while dimming the others
	var labels = $menucontent.get_children()
	for i in range(labels.size()):
		if i == selected_move_index:
			labels[i].add_theme_color_override("font_color", Color.YELLOW)
		else:
			labels[i].add_theme_color_override("font_color", Color.WHITE)

func show_enemy_selection():
	$menucontent.hide()
	$flavortext.show()
	# Replace text with target list
	$flavortext.text = "* Select a target." 

func handle_enemy_selection(event, current_choice):
	if event.is_action_pressed("ACCEPT"):
		$"../../Select".play()
		# Confirm target and advance tracking variable
		playermoves += 1
		
		if playermoves >= 2 or (purple_d or violet_d):
			# Both choices locked in! Proceed out of menu phase entirely
			current_state = MenuState.DIALOGUE
			execute_all_combat_choices()
		else:
			# Reset layout for the next character's screen inputs
			current_state = MenuState.TAB_SELECT
			$flavortext.text = $"../../board".data["flavor"] # Restore current turn text
			selected_tab = 0
			update_tab_visuals()

	elif event.is_action_pressed("BACK"):
		$"../../Deselect".play()
		if playermoves == 1 && not purple_d and not violet_d:
			# UNDO BACK TO PURPLE: Violet cancels out to give control back to Purple
			playermoves = 0
			purple_choice = null
			current_state = MenuState.TAB_SELECT
			$flavortext.text = $"../../board".data["flavor"]
		else:
			# Cancel enemy targeting, fall back to move selection menu
			if selected_tab == 1:
				$flavortext.hide()
				$menucontent.show()
				current_state = MenuState.MOVE_SELECT
			else:
				current_state = MenuState.TAB_SELECT

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, false, 2.0)
	
func update_tab_visuals():
	var tabmove = create_tween()
	$"../../LightningbulbSpacebarClickKeyboard199448".play()
	for i in range(tabs.size()):
		if i == selected_tab:
			tabs[i].modulate = Color.YELLOW
			tabmove.tween_property(tabs[i], "position:y", -40, 0.1).set_trans(Tween.TRANS_LINEAR)
		else:
			tabs[i].modulate = Color.WHITE
			tabmove.tween_property(tabs[i], "position:y", -32, 0.1).set_trans(Tween.TRANS_LINEAR)

func show_special(character_name):
	$flavortext.hide() # Hide the flavor text
	$menucontent.show()
	
	for child in $menucontent.get_children():
		child.queue_free()
	
	var moves = purple_specials if character_name == "Purple" else violet_specials
	
	# create specials list
	for i in range(moves.size()):
		var move = moves[i]
		var move_label = Label.new()
		move_label.text = move["name"] + " (" + str(move["cost"]) + " TP)"
		# Add logic here to highlight the label based on arrow keys
		$menucontent.add_child(move_label)
