extends Sprite2D

@export var hp = 100
@export var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"../hud/mc1/hp1".value = hp
	if hp <= 0:
		dead = true
		dissipate()
		$"../../Spanked".play()
	else:
		dead = false

func dissipate():
	var tween = create_tween()
	# Access the shader parameter directly through the material
	tween.tween_property(self.material, "shader_parameter/dissolve_value", 1.1, 1.5)
	
	# Wait for animation to finish then delete
	await tween.finished
	queue_free()
