extends Control

func _ready():
	if !Difficulty.getLevel(): $Play4.disabled = true

func playGame():
	Difficulty.resetLevel()
	cont()

func toDeck():
	get_tree().change_scene_to_file("res://menu/deckeditor.tscn")

func exit():
	get_tree().quit()

func cont():
	get_tree().change_scene_to_file("res://game/game.tscn")
