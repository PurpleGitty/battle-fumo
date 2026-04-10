extends Sprite2D

var hp = 10000
@export var focus = 0

@export var turnboxsize = [
	Vector2(16, 16), # fake turn
	Vector2(128, 128),
	Vector2(128, 256),
	Vector2(256, 128)
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../../board".turnchanged.connect(on_board_turn_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_board_turn_changed(yourturn):
	focus = randi() % 5
