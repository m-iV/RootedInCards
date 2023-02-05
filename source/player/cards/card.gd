extends Control

# Emitted when the player uses the card
signal used

# Normal position of the node
@onready var normalPos: Vector2 = $Card.position
# The minimum size for the control node
@onready var minSize: Vector2 = custom_minimum_size
# How far the card moves when hovered
var posChange: Vector2 = Vector2(0, -75)
# is the mouse over
var mouseOver: bool = false
# Are we viewing the card in large?
var largeCard: bool = false
# The ID of the card for use in skills
var cardID: int = 0
# Has the card been used
var card_used: bool = false

func _ready():
	$AudioStreamPlayer.play()
	$Card.scale = Vector2(0, 0)
	custom_minimum_size.x = 0
	create_tween().tween_property(self, "custom_minimum_size", minSize, 0.5)

func setup_id(id: int):
	cardID = id
	$Card.setup(id)
	normalPos = $Card.position


func _process(delta):
	if !card_used:
		var newPos: Vector2 = normalPos
		var newScale: float = 1
		if mouseOver: 
				newPos += posChange
				newScale = 1.2
		if largeCard: newPos += posChange
		$Card.position = lerp($Card.position, newPos, 10 * delta)
		$Card.scale.x = lerp($Card.scale.x, newScale, 10 * delta)
		$Card.scale.y = lerp($Card.scale.y, newScale, 10 * delta)

func _input(event):
	if card_used: return
	if !player_turn():
		largeCard = false
	elif event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if largeCard and mouseOver:
			$AudioStreamPlayer2.play()
			mark_used()
			emit_signal("used", cardID)
		elif largeCard: largeCard = false
		elif mouseOver: largeCard = true

# What to do when the card is used.
func mark_used() -> void:
	if !is_usable(): return
	card_used = true
	var tween: Tween = create_tween()
	tween.tween_property(self, "custom_minimum_size", Vector2.ZERO, 0.5)
	create_tween().tween_property(self, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	queue_free()

# Mouse collision
func _mouse_entered(): mouseOver = true
func mouse_exited(): mouseOver = false

func is_usable() -> bool: return !card_used

func player_turn() -> bool:
	return get_parent().get_parent().turn == get_parent().get_parent().turns.PLAYER
