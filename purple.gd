extends Sprite2D

signal purple_d(dead)
@export var hp = 100
@export var dead = false:
	set(value):
		if dead == value: return
		dead = value
		if dead:
			start_death()
		else:
			revive()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"../hud/mc1/hp1".value = hp
	if hp <= 0:
		dead = true
	else:
		dead = false

func start_death():
	$"../../Spanked".play()
	var tween = create_tween()
	tween.tween_property(self.material, "shader_parameter/dissolve_value", 1.1, 1.5)
	
	var bar = $"../hud/mc1/hp1"
	bar.self_modulate = Color.GREEN # Make it green for revival
	bar.max_value = 60.0
	bar.value = 0.0
	
	# Wait for animation to finish then delete
	var bar_tween = create_tween()
	bar_tween.tween_property(bar, "value", 60.0, 60.0).set_trans(Tween.TRANS_LINEAR)
	
	await get_tree().create_timer(60.0).timeout
	self.dead = false # This triggers the 'else' in the setter

func revive():
	hp = 100
	var bar = $"../hud/mc1/hp1"
	bar.self_modulate = Color.YELLOW
	bar.max_value = 100 # Reset to HP max
	bar.value = hp
	var tween = create_tween()
	tween.tween_property(self.material, "shader_parameter/dissolve_value", 0.0, 1.5)
