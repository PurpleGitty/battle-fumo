extends CharacterBody2D


const SPEED = 128
@onready var focusdamage = $"../CanvasLayer/testicina".focus * .25
var invincibility = false

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction && $"../board".yourturn == false:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func _on_bullet_collision_area_entered(area: Area2D) -> void:
	if invincibility:
		return
		
	if "damage" in area && !$"../board".yourturn:
		take_damage(area.damage)
			
func take_damage(amount):
	invincibility = true
	$"../AudioStreamPlayer2D".play()
	
	
	var purple_mult = $"../CanvasLayer/testicina".focus / 4.0
	var violet_mult = 1.0 - purple_mult
	
	var purple = $"../CanvasLayer/purple"
	var violet = $"../CanvasLayer/violet"

	if not purple.dead and not violet.dead:
		purple.hp -= floor(amount * purple_mult)
		violet.hp -= floor(amount * violet_mult)
	elif not purple.dead:
		purple.hp -= amount
	elif not violet.dead:
		violet.hp -= amount
	
	await get_tree().create_timer(1.0).timeout
	invincibility = false
	for area in $"bullet collision".get_overlapping_areas():
		if "damage" in area && !$"../board".yourturn:
			take_damage(area.damage)
			break
