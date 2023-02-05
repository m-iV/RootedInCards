extends Panel


# Text box
@onready var nameText: Label = $Panel2/Name
@onready var descText: Label = $Panel2/Desc


func setup(id: int):
	# Card data
	var cards: Cards = Cards.new()
	var cName: String = cards.cards[id].name
	var cDesc: String = cards.cards[id].description
	# Setup the card and ID
	setup_visual(cName, cDesc)
	# Setup the picture
	if cards.cards[id].has("img"): $Image.texture = load("res://images/cards/%s.png" % [cards.cards[id].img])
	else:
		var textures: Array = cards.cards[id].imgs
		var texture: String = textures[randi_range(0, textures.size() - 1)]
		$Image.texture = load("res://images/cards/%s.png" % [texture])

func setup_visual(cardName: String, cardDesc: String):
	nameText = $Panel2/Name
	descText = $Panel2/Desc
	nameText.text = cardName
	descText.text = cardDesc
