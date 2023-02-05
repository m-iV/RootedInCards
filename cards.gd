extends Node

class_name Cards

enum fnc {
	_heal,
	_shield,
	_drawCard,
	_sacCard,
	_destroyCard,
	_attack,
	_player,
	_playerNoTurn,
	_getRNGCardFList,
	_randomEffect
}

const cards: Array = [
	{ # 00
		"name": "Attack",
		"description": "Attacks the Evil Tree",
		"imgs": ["Attack", "Attack_3"],
		"ability": [
			[fnc._attack, [20, 7]]
		]
	},
	{ # 01
		"name": "Major Damage",
		"description": "Strong attack that will give you Root Points in the process",
		"imgs": ["Major Damage 1", "Major Damage 2", "Major_Damage_4", "Major_Damage_5"],
		"ability": [
			[fnc._attack, [40, 15]],
			[fnc._heal, [-10, 5]]
		]
	},
	{ # 02
		"name": "Sneak Attack",
		"description": "Attack the Evil Tree and take another turn",
		"imgs": ["Sneak Attack", "Sneak2"],
		"ability": [
			[fnc._attack, [10, 7]],
			[fnc._player, []]
		]
	},
	{ # 03
		"name": "Leach",
		"description": "Attack the Evil Tree and destroy some Root Points in the process",
		"imgs": ["Leach", "Leach2", "Leach 1", "Leach_Axe"],
		"ability": [
			[fnc._attack, [10, 3]],
			[fnc._heal, [5, 3]],
		]
	},
	{ # 04
		"name": "Ready Attack",
		"description": "Gets two random attack cards\n\n" +
						"They don't have to be in your deck",
		"imgs": ["RAttack", "Ready_Attack"],
		"ability": [
			[fnc._getRNGCardFList, [2, 0, 0, 0, 1, 1, 1, 2, 3, 3, 3, 4]]
		]
	},
	{ # 05
		"name": "UnRoot",
		"description": "Removes some Root Points",
		"imgs": ["Unroot", "Unroot_2"],
		"ability": [
			[fnc._heal, [20, 7]]
		]
	},
	{ # 06
		"name": "Root Remover",
		"description": "Removes a lot of Root Points",
		"imgs": ["Root_Remover", "Root_Remover_2"],
		"ability": [
			[fnc._heal, [50, 20]]
		]
	},
	{ # 07
		"name": "Sac and Go",
		"description": "Sacrifice a card to remove Root Points, and play another card",
		"imgs": ["Sac and Go", "Sac_and_go_2"],
		"ability": [
			[fnc._destroyCard, [1]],
			[fnc._heal, [27, 5]],
			[fnc._playerNoTurn, []]
		]
	},
	{ # 08
		"name": "Last Chance",
		"description": "Sacrifice all cards to possibly remove all Root Points",
		"imgs": ["Last Chance", "Last_Chance_2"],
		"ability": [
			[fnc._destroyCard, [999]],
			[fnc._heal, [75, 75]],
		]
	},
	{ # 09
		"name": "Root Shield",
		"description": "Gain Root Point resistance for one round",
		"imgs": ["Root_Shield", "Root_Shield_2"],
		"ability": [
			[fnc._shield, [0.4, 1]]
		]
	},
	{ # 10
		"name": "Large Shield",
		"description": "Gain Root Point resistance for two rounds",
		"imgs": ["Large_Shield", "Large_Shield_2"],
		"ability": [
			[fnc._shield, [0.3, 2]]
		]
	},
	{ # 11
		"name": "Preparation",
		"description": "Gain Root Point Resistance and take another turn",
		"imgs": ["prep", "Preparation_2"],
		"ability": [
			[fnc._shield, [0.3, 3]],
			[fnc._player, []]
		]
	},
	{ # 12
		"name": "Emotional Dmg",
		"description": "Attacks the evil tree and gives you temporary Root Point resistance",
		"imgs": ["Emotional_Damage", "Emotional_Damage_2"],
		"ability": [
			[fnc._attack, [10, 5]],
			[fnc._shield, [0.5, 3]]
		]
	},
	{ # 13
		"name": "Draw",
		"description": "Draw an extra card this turn",
		"imgs": ["Draw", "Draw2"],
		"ability": [
			[fnc._drawCard, [1]]
		]
	},
	{ # 14
		"name": "Double-Draw",
		"description": "Draw two extra cards this turn",
		"imgs": ["Double Draw", "Draw22"],
		"ability": [
			[fnc._drawCard, [2]]
		]
	},
	{ # 15
		"name": "Re-Draw",
		"description": "Sacrifice a random card for a new one",
		"imgs": ["Re Draw", "Re_Draw_2"],
		"ability": [
			[fnc._sacCard, [1]]
		]
	},
	{ # 16
		"name": "Total Reset",
		"description": "Sacrifice all cards for a new set",
		"imgs": ["Total Reset", "Total Rese2", "Total Rese3", "Total_Reset_ee"],
		"ability": [
			[fnc._sacCard, [999]]
		]
	},
	{ # 17
		"name": "Fill Hand",
		"description": "Draws cards to the maximum hand size",
		"imgs": ["Fill_Hand", "refill"],
		"ability": [
			[fnc._drawCard, [999]]
		]
	},
	{ # 18
		"name": "Take a Risk",
		"description": "Something random will happen!",
		"imgs": ["Take_a_Risk", "Take_a_Risk2", "Take__Risk", "Take_a_Risk_3", "Took_the_Risk", "What_I3", "What_I4", "What_If2", "What_If"],
		"ability": [
			[fnc._randomEffect, [
				[fnc._drawCard, [999]],
				[fnc._destroyCard, [999]],
				[fnc._sacCard, [999]],
				[fnc._attack, [10, 3]],
				[fnc._attack, [-20, 5]],
				[fnc._heal, [5, 3]],
				[fnc._heal, [-10, 5]]
			]]
		]
	}
]

const punishments: Array = [
	{
		"name": "Rooted",
		"anim": "idle",
		"ability": [
			[fnc._heal, [-25, 10]]
		]
	},
	{
		"name": "Large Root",
		"anim": "idle",
		"ability": [
			[fnc._heal, [-35, 10]]
		]
	},
	{
		"name": "Takeback",
		"anim": "idle",
		"ability": [
			[fnc._heal, [3, 2]],
			[fnc._attack, [-10, 5]]
		]
	},
	{
		"name": "Consume",
		"anim": "idle",
		"ability": [
			[fnc._heal, [-10, 3]],
			[fnc._attack, [-30, 5]]
		]
	},
	{
		"name": "Grow",
		"anim": "idle",
		"ability": [
			[fnc._attack, [-20, 10]],
		]
	},
	{
		"name": "Jumpscare",
		"anim": "idle",
		"ability": [
			[fnc._sacCard, [1]]
		]
	},
	{
		"name": "Slam",
		"anim": "idle",
		"ability": [
			[fnc._heal, [-30, 20]]
		]
	},
	{
		"name": "Downfall",
		"anim": "idle",
		"ability": [
			[fnc._heal, [-7, 5]],
			[fnc._destroyCard, [1]],
			[fnc._sacCard, [2]]
		]
	},
	{
		"name": "Entrap",
		"anim": "idle",
		"ability": [
			[fnc._heal, [-35, 10]],
			[fnc._destroyCard, [1]]
		]
	}
]


func getFunctionFromCard(id: int) -> Array:
	var funcs: Array = cards[id].ability
	return funcs

func getFunctionFromFID(id: int) -> String:
	return fnc.keys()[id]

func getRandomEnemy() -> Array:
	# Get a random punishment
	var punishment: int = randi_range(0, punishments.size() - 1)
	var pDict: Dictionary = punishments[punishment]
	# Setup the array
	var pArray: Array = [pDict.name]
	pArray.append(pDict.anim)
	pArray.append_array(pDict.ability)
	return pArray
