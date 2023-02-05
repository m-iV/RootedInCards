extends HBoxContainer

# Used when a card is used
signal card

# Packed scene of the card
@onready var card_scene: PackedScene = preload("res://player/cards/cardscene.tscn")
# Normal position of the hand
@onready var normalPos: Vector2 = position
# How far the position changes when it's not the player's turn
var posChange: Vector2 = Vector2(0, 75)

# Add three cards to the player's hand when the game starts
func _ready():
	add_random_cards(3)

func _process(delta):
	var newPos: Vector2 = normalPos
	if get_parent().turn != get_parent().turns.PLAYER: newPos += posChange
	position = lerp(position, newPos, 10 * delta)


func add_card(id: int):
	if get_card_count() >= 6: return
	var card_instance = card_scene.instantiate()
	card_instance.name = str("Card %s" % [str(randi())])
	add_child(card_instance)
	card_instance.setup_id(id)
	card_instance.connect("used", card_used, CONNECT_ONE_SHOT)

func card_used(id: int):
	emit_signal("card", id)

func add_random_cards(amount: int):
	for _i in amount:
		add_random_card()

func add_random_card():
	add_card(Deck.drawCard())

func get_card_count() -> int:
	var currentCards: int = 0
	for child in get_children():
		if child.is_usable(): currentCards += 1
	return currentCards

func get_active_cards() -> Array:
	# Get the active cards
	var cardsToSack: Array = []
	for _card in get_children(): if _card.is_usable(): cardsToSack.append(_card)
	return cardsToSack
