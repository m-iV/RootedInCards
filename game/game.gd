extends Control

# Turn enum
enum turns {
	NONE,
	PLAYER,
	ENEMY,
	GAMEOVER,
	NOTHING
}

# Who's turn it is
var turn: turns = turns.NONE
# Cards thing
var cards: Cards = Cards.new()
# Player HP [Damage taken, Max]
var playerHP: Array = [0, 100]
# Evil HP [Damage taken, Max]
var evilHP:   Array = [0, 100]
# The amount of shield the player has
var playerShield: Array = []
# Does the shield blue currently show up?
var shieldBlue: bool = false
# Make sure the player can't just take 100 turns in a row
var playerTurnsInRow: int = 0
# Level Difficulty
var diff: Dictionary

func _ready():
	$Hand.connect("card", do_card)
	turn = turns.PLAYER
	$TextureRect/Skewit.play("skew")
	
	diff = Difficulty.getLevelStats()
	playerHP[1] = diff.pHP
	evilHP[1] = diff.eHP

func _process(delta):
	if turn == turns.ENEMY: do_enemy()
	$EnemyHealth.max_value = evilHP[1]
	var val: float = $EnemyHealth.value
	var shouldVal: float = float(evilHP[1] - evilHP[0])
	if val < shouldVal: val += delta
	elif val > shouldVal: val -= delta
	$EnemyHealth.value = lerp(val, shouldVal, 3 * delta)
	
	var halfMax: float = float(playerHP[1]) / 4
	var cameraMod: float = max(playerHP[0] - halfMax, 0.0) / halfMax
	$Damage.modulate.a = lerp($Damage.modulate.a, cameraMod, 2 * delta)
	halfMax = float(playerHP[1]) / 2
	cameraMod = max(playerHP[0] - halfMax, 0.0) / halfMax
	var shader_param: float = $DmgVin.get_material().get_shader_parameter("modulate")
	shader_param = lerp(shader_param, cameraMod, delta)
	$DmgVin.get_material().set_shader_parameter("modulate", shader_param)
	
	# Tree Fading
	$TextureRect.frame = int(float(evilHP[0]) / (float(evilHP[1]) / 4.0))
	if evilHP[0] >= evilHP[1]: $TextureRect.frame = 4


	if evilHP[1] <= evilHP[0] and turn != turns.NOTHING:
		print("Player Wins")
		$gameover.text = "You Win!"
		$gameoversmol.text = "Level %d Completed" % [Difficulty.getLevel()]
		Difficulty.levelUp()
		$Enemu.hide()
		if Difficulty.hasWon():
			$gameoversmol.text = "Final Level Complete!"
			Difficulty.resetLevel()
		turn = turns.GAMEOVER
	if playerHP[1] <= playerHP[0] and turn != turns.NOTHING:
		print("Evil Wins")
		$gameover.text = "Game Over"
		$gameoversmol.text = "Final Level: %d" % [Difficulty.getLevel()]
		turn = turns.GAMEOVER
		$Camera.shake(15, 15)
		await get_tree().process_frame
		Difficulty.resetLevel()
	if turn == turns.GAMEOVER:
		turn = turns.NOTHING
		var tween: Tween = create_tween()
		tween.tween_interval(2)
		tween.tween_property($gameover, "modulate", Color.WHITE, 0.5)
		tween.tween_property($gameoversmol, "modulate", Color.WHITE, 0.3)
		tween.tween_interval(3)
		tween.tween_property($gameover, "modulate", Color(1, 1, 1, 0), 2)
		tween.tween_property($Fadeout, "modulate", Color(0, 0, 0, 1), 2)
		await tween.finished
		get_tree().change_scene_to_file("res://menu/menu.tscn")


func do_enemy():
	# Reset the amount of turns in a row the player has done
	playerTurnsInRow = 0
	# Set the turn to nobody so this doesn't get called again
	turn = turns.NONE
	# TODO: Enemy Turn
	await get_tree().create_timer(1).timeout
	# Make sure the game hasn't ended
	if turn == turns.GAMEOVER or turn == turns.NOTHING: return 
	# Get the calls that the enemy's ability has
	var calls: Array = cards.getRandomEnemy()
	# Print the attack being used
	var attack: String = calls.pop_front()
	print(attack)
	# Display the message of the move being used
	# and then wait half a second before making the move
	$EnemuMove.text = attack
	create_tween().tween_property($EnemuMove, "modulate", Color.WHITE, 0.1)
	await get_tree().create_timer(1).timeout
	create_tween().tween_property($EnemuMove, "modulate", Color(1, 1, 1, 0), 1.5)
	# Animate the enemy
	$Enemu.animation = calls.pop_front()
	# Call them
	for _call in calls: call(cards.getFunctionFromFID(_call[0]), _call[1].duplicate())
	await get_tree().create_timer(1).timeout
	# Make sure the tree is idling
	$Enemu.animation = "idle"
	# Change to the player's turn
	change_to_player()

# Change the turn to the player
func change_to_player() -> void:
	# Give the player a card
	$Hand.add_random_card()
	# Lower shield counters
	for shield in playerShield:
		shield[1] -= 1
		if shield[1] <= 0: playerShield.erase(shield)
	# Wait for the card to fully generate
	await get_tree().create_timer(0.5).timeout
	# Fade the shield correctly
	if playerShield.is_empty() and shieldBlue:
		shieldBlue = false
		create_tween().tween_property($Camera/Shield, "modulate", Color(1, 1, 1, 0), 0.2)
	# Set the turn so the player can do things
	turn = turns.PLAYER

func do_card(cardID: int):
	turn = turns.NONE
	# Wait just a touch
	await get_tree().create_timer(1).timeout
	# Set the turn to the enemy's turn in case a card changes it back
	turn = turns.ENEMY
	# Get the calls that the player's card has
	var calls: Array = cards.getFunctionFromCard(cardID)
	# Call them
	for _call in calls: call(cards.getFunctionFromFID(_call[0]), _call[1].duplicate())


###############
### Effects ###
###############

func _heal(args: Array):
	# Extract the args
	var value: int = args[0]
	var dist: int = args[1]
	# Modify the heal value
	value += randi_range(-dist, dist)
	# Apply resistance if it's dealing damage
	if value < 0 and playerShield.size():
		print("Shield Taking Effect")
		var shieldValue: float = 0
		for shield in playerShield: shieldValue += shield[0]
		shieldValue = 1 - min(1, shieldValue)
		print("Pre Shield Value: %d" % value)
		value = int(float(value) * shieldValue)
		print("Post Shield Value: %d" % value)
	# Do screenshake if damage was delt
	if value < 0:
		$Camera.shake(int(float(value) / 3))
		$Camera.flash()
		$Audio/Hit.pitch_scale = randf_range(0.5, 0.8)
		$Audio/Hit.play()
	else: if playerHP[0]: $Camera.flash(Color(0, 1, 0, 0.1))
	# Heal the player
	playerHP[0] = max(playerHP[0] - value, 0) 

func _shield(args):
	playerShield.append(args)
	if !shieldBlue:
		shieldBlue = true
		create_tween().tween_property($Camera/Shield, "modulate", Color(1, 1, 1, 1), 0.2)

func _drawCard(args: Array):
	var amount: int = args[0]
	$Hand.add_random_cards(amount)

func _sacCard(args: Array):
	# Get the amount of cards that wants to be replaced
	var cToSack: int = args[0]
	# Get the amount of cards possible to sack
	var cardsToSack: Array = $Hand.get_active_cards()
	cToSack = min(cToSack, cardsToSack.size())
	# Sacrifice the cards
	for sack in cToSack:
		var toSack: Node = cardsToSack[randi_range(0, cardsToSack.size() - 1)]
		toSack.mark_used()
		cardsToSack.erase(toSack)
	# Draw the cards back
	$Hand.add_random_cards(cToSack)

func _destroyCard(args: Array):
	# Get the amount of cards that wants to be replaced
	var cToSack: int = args[0]
	# Get the amount of cards possible to sack
	var cardsToSack: Array = $Hand.get_active_cards()
	cToSack = min(cToSack, cardsToSack.size())
	# Sacrifice the cards
	for sack in cToSack:
		var toSack: Node = cardsToSack[randi_range(0, cardsToSack.size() - 1)]
		toSack.mark_used()
		cardsToSack.erase(toSack)

func _attack(args: Array):
	# Extract the args
	var value: int = args[0]
	var dist: int = args[1]
	# Modify the heal value
	value += randi_range(-dist, dist)
	# Do camera shake if the enemy is taking damage
	if value > 0:
		$Camera.shake(float(value) / 4.0)
		$Audio/Hit.pitch_scale = randf_range(0.7, 1.3)
		$Audio/Hit.play()
		# Flash the enemy on hit
		var tween: Tween = create_tween()
		for _i in int(float(value) / 7.0) + 1:
			tween.tween_property($Enemu, "modulate", Color(1, 1, 1, 0), 0.1)
			tween.tween_property($Enemu, "modulate", Color.WHITE, 0.1)
	else:
		print("Enemy Heal Modified: Pre = %d" % [value])
		value *= diff.eHM
		print("Enemy Heal Modified: Post = %d" % [value])
	# Heal / damage the enemy
	evilHP[0] = max(evilHP[0] + value, 0) 

func _player(_args: Array):
	turn = turns.NONE
	await get_tree().create_timer(1).timeout
	playerTurnsInRow += 1
	if playerTurnsInRow < 3: change_to_player()
	else: turn = turns.ENEMY

func _playerNoTurn(_args: Array):
	turn = turns.NONE
	await get_tree().create_timer(1).timeout
	turn = turns.PLAYER
	# If the player has no more cards, go to the enemy's turn
	if $Hand.get_card_count() <= 0: turn = turns.ENEMY


func _getRNGCardFList(args: Array):
	# Get the amount of cards they want to draw
	var amount: int = args.pop_front()
	# Draw the cards
	for _i in amount:
		# Shuffle the args so I can add the first one
		args.shuffle()
		$Hand.add_card(args.pop_front())

func _randomEffect(args: Array):
	args.shuffle()
	var _call: Array = args.pop_front()
	call(cards.getFunctionFromFID(_call[0]), _call[1].duplicate())
