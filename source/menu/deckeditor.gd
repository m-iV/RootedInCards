extends Control

@onready var cardNode: PackedScene = preload("res://player/cards/card.tscn")
@onready var cardCount: PackedScene = preload("res://player/cards/cardcount.tscn")
@onready var container: Control = $MarginContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in container.get_children(): child.queue_free()
	var cards: Cards = Cards.new()
	for card in cards.cards.size():
		var iCount: Node = cardCount.instantiate()
		iCount.id = card
		iCount.get_node("SpinBox").value = Deck.getCountOf(card)
		iCount.get_node("SpinBox").prefix = "%s:" % [cards.cards[card].name]
		container.add_child(iCount)
		var iCard: Node = cardNode.instantiate()
		iCard.setup(card)
		iCount.add_child(iCard, false, Node.INTERNAL_MODE_FRONT)
		iCard.custom_minimum_size = Vector2(200, 300)

func save():
	Deck.clear()
	for child in container.get_children():
		for i in child.get_node("SpinBox").value: Deck.addToDeck(child.id)
	get_tree().change_scene_to_file("res://menu/menu.tscn")

func clear():
	Deck.clear()
	_ready()

func reset():
	_ready()

func fullReset():
	Deck.setupBasedeck()
	_ready()

func saveToDisk():
	$FileDialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	$FileDialog.popup()

func openLoad():
	$FileDialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	$FileDialog.popup()

func loadDeck(path):
	if $FileDialog.file_mode == FileDialog.FILE_MODE_SAVE_FILE:
		Deck.saveDeck(path)
	else:
		Deck.loadDeck(path)
		_ready()
