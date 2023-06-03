Config = {}

Config.paleto_electrician = {
	WorkPoints = {
		{x = -285.94, y = 6020.37, z = 30.47},
		{x = -289.64, y = 6023.75, z = 30.47},
		{x = -296.59, y = 6019.99, z = 30.47},
		{x = -293.35, y = 6016.58, z = 30.47}
	},

	Clothes = {
		male = {
			['arms'] = 2, ['glasses_1'] = 0,
			['chain_1'] = 0,
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 65,   ['torso_2'] = 3,
			['pants_1'] = 38, ['pants_2'] = 3,
			['shoes_1'] = 51
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 4,   ['torso_2'] = 14,
			['arms'] = 4,
			['pants_1'] = 25,   ['pants_2'] = 1,
			['shoes_1'] = 16,   ['shoes_2'] = 4,
		}
	},
	QuestGiver = {
		NPCHash	= 0x867639D1,
		x = -285.38,
		y = 6029.76,
		z = 30.47,
	}
}

Config.paleto_factory_helper = {
	WorkPoints = {
		{x = -86.42, y = 6237.5, z = 30.09, type = 'computer'},
		{x = -77.95, y = 6224.49, z = 30.09, type = 'computer'},
		{x = -69.34, y = 6256.13, z = 30.09, type = 'archive'}
	},

	Clothes = {
		male = {
			['arms'] = 2, ['glasses_1'] = 0,
			['chain_1'] = 0,
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 56,   ['torso_2'] = 0,
			['pants_1'] = 27, ['pants_2'] = 7,
			['shoes_1'] = 51
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 4,   ['torso_2'] = 14,
			['arms'] = 4,
			['pants_1'] = 25,   ['pants_2'] = 1,
			['shoes_1'] = 16,   ['shoes_2'] = 4,
		}
	},

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
	Clothes = {
		male = {
			['arms'] = 2, ['glasses_1'] = 0,
			['chain_1'] = 0,
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 65,   ['torso_2'] = 3,
			['pants_1'] = 38, ['pants_2'] = 3,
			['shoes_1'] = 51
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 4,   ['torso_2'] = 14,
			['arms'] = 4,
			['pants_1'] = 25,   ['pants_2'] = 1,
			['shoes_1'] = 16,   ['shoes_2'] = 4,
		}
	},
	QuestGiver = {
		NPCHash = 0xF06B849D,
		x = 1.68,
		y = 6427.31,
		z = 30.43,
	}
}