extends Sprite2D

@export var hp = 100
@export var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"../hud/mc2/hp2".value = hp
	if hp <= 0:
		dead = true
	else:
		dead = false
