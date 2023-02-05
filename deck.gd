extends Node

class_name deck_script

# The deck is an array of card IDs
# NOT TO BE USED OUTSIDE OF THIS SCRIPT
var _deck: Array = []

# Cards that can be drawn
var _canDraw: Array = []

func _ready():
	setupBasedeck()

## Adds a card ID to the deck.
## Pushes an error if the card doesn't exist.
func addToDeck(id: int, amount: int = 1) -> void:
	if id >= Cards.new().cards.size(): push_error("Card ID Too High")
	for _i in amount: _deck.append(id)
	_deck.sort()

func shuffleDeck() -> void:
	_canDraw = _deck.duplicate()
	_canDraw.shuffle()

func drawCard() -> int:
	# Shuffle the deck if you can't draw anything
	if _canDraw.is_empty(): shuffleDeck()
	if _canDraw.is_empty(): setupBasedeck()
	# Draw the top card
	return _canDraw.pop_front()

func getDeck() -> Array:
	return _deck.duplicate()

func setupBasedeck() -> void:
	_deck.clear()
	var cards: Cards = Cards.new()
	for card in cards.cards.size(): for _i in 5: _deck.append(card)
	shuffleDeck()

func getCountOf(id: int) -> int:
	var amount: int = 0
	_deck.sort()
	
	for i in _deck:
		if i == id: amount += 1
		elif i > id: break
	
	return amount

func clear() -> void:
	_canDraw.clear()
	_deck.clear()


func saveDeck(path: String):
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_var(_deck)
	file = null #closing files is weird now

func loadDeck(fileName: String):
	var file: FileAccess = FileAccess.open(fileName, FileAccess.READ)
	_deck = file.get_var()
	file = null #closing files is weird now
