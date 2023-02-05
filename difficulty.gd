extends Node

# The current level
var _level: int = 0

const _levelStats: Array = [
	{
		"pHP": 200,
		"eHP": 50,
		"eHM": 0.5
	},
	{
		"pHP": 150,
		"eHP": 75,
		"eHM": 1
	},
	{
		"pHP": 125,
		"eHP": 100,
		"eHM": 1
	},
	{
		"pHP": 100,
		"eHP": 100,
		"eHM": 1
	},
	{
		"pHP": 90,
		"eHP": 100,
		"eHM": 1
	},
	{
		"pHP": 80,
		"eHP": 100,
		"eHM": 1
	},
	{
		"pHP": 75,
		"eHP": 100,
		"eHM": 1
	},
	{
		"pHP": 75,
		"eHP": 125,
		"eHM": 1
	},
]

func getLevelStats(level: int = _level) -> Dictionary:
	return _levelStats[level].duplicate()

func levelUp() -> void:
	_level += 1

func resetLevel() -> void:
	_level = 0

func getLevel() -> int:
	return _level

func getLevels() -> int:
	return _levelStats.size()

func hasWon() -> bool:
	return getLevel() >= getLevels()
