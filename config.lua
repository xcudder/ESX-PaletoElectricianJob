Config = {}

Config.paleto_electrician = {
	WorkPoints = {
		{x = -285.94, y = 6020.37, z = 30.47, heading = 40.14},
		{x = -289.64, y = 6023.75, z = 30.47, heading = 41.03},
		{x = -296.59, y = 6019.99, z = 30.47, heading = 128.39},
		{x = -293.35, y = 6016.58, z = 30.47, heading = 134.39}
	},

	Clothes = {
		{ -- grade 0
			male = {
				['arms'] = 2, ['glasses_1'] = 0,
				['chain_1'] = 0,
				['tshirt_1'] = 15,  ['tshirt_2'] = 0,
				['torso_1'] = 65,   ['torso_2'] = 3,
				['pants_1'] = 38, ['pants_2'] = 3,
				['shoes_1'] = 51, ['shoes_2'] = 3,
			},
			female = {}
		},
		{ -- grade 1
			male = {
				['arms'] = 63, ['glasses_1'] = 0,
				['chain_1'] = 0,
				['tshirt_1'] = 15,  ['tshirt_2'] = 0,
				['torso_1'] = 66,   ['torso_2'] = 1,
				['pants_1'] = 39, ['pants_2'] = 1,
				['shoes_1'] = 31, ['shoes_2'] = 2,
				['helmet_1'] = 76
			},
			female = {}
		},
		{ -- grade 2
			male = {
				['arms'] = 96, ['glasses_1'] = 1,
				['chain_1'] = 0,
				['tshirt_1'] = 74,  ['tshirt_2'] = 3,
				['torso_1'] = 66,   ['torso_2'] = 1,
				['pants_1'] = 39, ['pants_2'] = 1,
				['shoes_1'] = 54, ['shoes_2'] = 0,
				['glasses_1'] = 4, ['glasses_2'] = 9
			},
			female = {}
		},
		{ -- grade 3
			male = {
				['arms'] = 96, ['glasses_1'] = 1,
				['chain_1'] = 0,
				['tshirt_1'] = 74,  ['tshirt_2'] = 3,
				['torso_1'] = 66,   ['torso_2'] = 1,
				['pants_1'] = 39, ['pants_2'] = 1,
				['shoes_1'] = 54, ['shoes_2'] = 0,
				['glasses_1'] = 4, ['glasses_2'] = 9
			},
			female = {}
		}
	},

	QuestGiver = {
		NPCHash	= 0x867639D1,
		x = -285.38,
		y = 6029.76,
		z = 30.47,
	},

	PromotionThreshold = {
		grade1 = 4000,
		grade2 = 40000,
		grade3 = 100000,
	}
}

Config.paleto_factory_helper = {
	WorkPoints = {
		{x = -86.42, y = 6237.5, z = 30.09, heading = 50.24, type = 'computer'},
		{x = -77.95, y = 6224.49, z = 30.09, heading = 24.60, type = 'computer'},
		{x = -69.34, y = 6256.13, z = 30.09, heading = 41.42, type = 'archive'}
	},

	Clothes = {{
		male = {
			['arms'] = 2, ['glasses_1'] = 0,
			['chain_1'] = 0,
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 56,   ['torso_2'] = 0,
			['pants_1'] = 27, ['pants_2'] = 7,
			['shoes_1'] = 51
		},
		female = {}
	}},

	QuestGiver = {
		NPCHash = 0x62018559,
		x = -73.09,
		y = 6266.6,
		z = 30.26
	}
}

Config.paleto_cleaner = {
	WorkPoints = {
		['low-end'] = {
			{ x = 264.52, y = -997.25, z = -100.01, active = 1 },
			{ x = 254.17, y = -1000.8, z = -99.93, active = 1 },
			{ x = 259.8, y = -1003.74, z = -100.01, active = 1 }
		},
		['mid-end'] = {
			{ x = 346.81, y = -1012.83, z = -100.2, active = 1 },
			{ x = 349.89, y = -1007.5, z = -100.2, active = 1 },
			{ x = 342.95, y = -1001.86, z = -100.2, active = 1 },
			{ x = 338.21, y = -996.64, z = -100.2, active = 1 },
			{ x = 347.01, y = -995.39, z = -100.11, active = 1 }
		}
	},
	Clothes = {{
		male = {
			['arms'] = 2, ['glasses_1'] = 0,
			['chain_1'] = 0,
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 65,   ['torso_2'] = 3,
			['pants_1'] = 38, ['pants_2'] = 3,
			['shoes_1'] = 51
		},
		female = {}
	}},
	QuestGiver = {
		NPCHash = 0xF06B849D,
		x = 1.68,
		y = 6427.31,
		z = 30.43,
	}
}

Config.paleto_police_intern = {
	WorkPoints = {
		-- some duplicates are a lazy way of increasing probability
		{x = -446.48, y = 6008.81, z = 30.72, heading = 219.52},
		{x = -446.48, y = 6008.81, z = 30.72, heading = 219.52},
		{x = -444.73, y = 6010.51, z = 30.72, heading = 219.52},
		{x = -444.73, y = 6010.51, z = 30.72, heading = 219.52},
		{x = -446.48, y = 6008.81, z = 30.72, heading = 219.52},
		{x = -446.48, y = 6008.81, z = 30.72, heading = 219.52},
		{x = -444.73, y = 6010.51, z = 30.72, heading = 219.52},
		{x = -444.73, y = 6010.51, z = 30.72, heading = 219.52},
		{x = -449.69, y = 6010.19, z = 30.72, heading = 131.30, type = 'coffee'},
		{x = -447.52, y = 6013.59, z = 30.72, heading = 308.07, type = 'lunch_break'}
	},

	Clothes = {{
		male = {
			['arms'] = 11, ['glasses_1'] = 0,
			['chain_1'] = 0,
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['pants_1'] = 76, ['pants_2'] = 0,
			['shoes_1'] = 31, ['shoes_2'] = 0
		},
		female = {}
	}},
	QuestGiver = {
		NPCHash	= 0x15F8700D,
		x = -441.92,
		y = 6020.84,
		z = 30.49,
	}
}

Config.used_car_lot = {
	cars = {
		{name = 'emperor2', 	max = 10000, 	min = 6000},
		{name = 'asea', 		max = 20000, 	min = 16000},
		{name = 'ratloader', 	max = 8000, 	min = 7000},
		{name = 'voodoo2', 		max = 9000, 	min = 6000},
		{name = 'bodhi2', 		max = 16000, 	min = 11000},
		{name = 'dloader', 		max = 9000, 	min = 8000},
		{name = 'rebel', 		max = 15000, 	min = 11000},
		{name = 'tornado3', 	max = 15000, 	min = 9000},
		{name = 'surfer2', 		max = 18000, 	min = 12000},
		{name = 'faggio2', 		max = 4000, 	min = 2000},
		{name = 'ratbike', 		max = 5000, 	min = 2000},
		{name = 'club', 		max = 7000, 	min = 5000},
	}
}

Config.mugging_chance = 10
Config.armed_mugger = false