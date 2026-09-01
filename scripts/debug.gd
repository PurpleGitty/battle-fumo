extends RichTextLabel

@onready var debug = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DEBUG"):
		debug = !debug # This is a shorter way to flip true/false
		self.visible = debug

	# 1. Safely grab the nodes (or null if they are dead)
	var purple = get_node_or_null("../purple")
	var violet = get_node_or_null("../violet")
	var soul = get_node_or_null("../../soul")
	
	# 2. Convert values to strings or "DEAD"
	var p_hp = str(purple.hp) if purple else "DEAD"
	var v_hp = str(violet.hp) if violet else "DEAD"
	var s_pos = "(" + str(floor(soul.position.x)) + ", " + str(floor(soul.position.y)) + ")" if soul else "N/A"

	# 3. Build the final text
	self.text = "debug = " + str(debug) + \
		"\nsoul = " + s_pos + \
		"\npurple hp = " + p_hp + \
		"\nviolet hp = " + v_hp + \
		"\ninvincibility = " + (str(soul.invincibility) if soul else "N/A")
