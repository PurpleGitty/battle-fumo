extends Sprite2D

var hp = 10000
@export var focus = 0

@export var turn_data = [
	{
		"flavor": "This is flavor text!",
		"dialogue": "How are you viewing this? This isn't visible in-game!",
		"board_size": Vector2(64, 64),
		"attack_index": 0,
		"transition_time": 10.0,
		"enemy_turn_length": 10.0
	},
	{
		"flavor": "This is also flavor text!",
		"dialogue": "Ready for round two?",
		"board_size": Vector2(128, 128),
		"attack_index": 1,
		"transition_time": 10.0,
		"enemy_turn_length": 10.0
	},
		{
		"flavor": "Testicina looks bored.",
		"dialogue": "Ready for round one?",
		"board_size": Vector2(128, 128),
		"attack_index": 1,
		"transition_time": 5.0,
		"enemy_turn_length": 20.0
	},
		{
		"flavor": "People watch your showdown like popcorn in the microwave.",
		"dialogue": "Ready for round one?",
		"board_size": Vector2(128, 128),
		"attack_index": 1,
		"transition_time": 0.5,
		"enemy_turn_length": 10.0
	},
		{
		"flavor": "Down with Envy!",
		"dialogue": "Ready for round one?",
		"board_size": Vector2(128, 128),
		"attack_index": 1,
		"transition_time": 0.5,
		"enemy_turn_length": 10.0
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../../board".turnchanged.connect(on_board_turn_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_board_turn_changed(yourturn):
	focus = randi() % 5
