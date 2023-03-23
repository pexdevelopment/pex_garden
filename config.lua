Config                            = {}
Config.DrawDistance               = 30.0
Config.Locale                     = 'en'
Config.nameJob					  = 'garden' -- The name of the job. Important to not misspell or else it won't work
Config.Item						  = 'poolreceipt' -- Name of the item which is given and then sold by the player
Config.Multiplier				  = '100' -- This how much money do want so a 100x multiplier is 100$ for 1 receipt
Config.Cleantime				  = '20000' -- It is in ms so this would be 20 seconds
-- Controls
Config.KeyClean 				  =  38 -- Control for starting the cleaning in the marker.  || All controls can be found here https://docs.fivem.net/docs/game-references/controls/
Config.Key  					  =  38	-- Control for opening menus in markers	
Config.KeyJobStart 				  =  212 -- Control for starting and ending job


Config.Blip = {
	Sprite = 1,
	Color = 3,
}

Config.Vehicles = {
	Hash = "bison" -- Hash of the vehicle. All of the hashes can be found here https://gtahash.ru/car/
}


Config.WorkUniform = {
	job_wear = {
		male = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,
			['torso_1'] = 17, ['torso_2'] = 4,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 5,
			['pants_1'] = 16, ['pants_2'] = 3,
			['shoes_1'] = 16, ['shoes_2'] = 0,
			['helmet_1'] = 15, ['helmet_2'] = 1,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 2, ['tshirt_2'] = 0,
			['torso_1'] = 195, ['torso_2'] = 24,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 15,
			['pants_1'] = 16, ['pants_2'] = 11,
			['shoes_1'] = 16, ['shoes_2'] = 4,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0
		}
	  },
}


Config.Zones = {
	Cloakroom = {
		Pos = vector3(-1139.43, -200.15,  36.0),
		Type = 21,
		R = 255, 
		G = 255, 
		B = 255,
		Size = 1.0,
	},

	VehicleSpawn = {
		Pos = vector3(-1148.05, -202.69,  37.96),
		Type = 36,
		R = 255, 
		G = 255, 
		B = 255,
		Size = 1.0,
	},

	VehicleSpawnPoint = {
		Pos   = {x = -1151.57, y = -208.2, z = 37.5},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Heading = 200.49,
	},

	VehicleDeleter = {
		Pos = vector3(-1154.24, -227.83,  37.9),
		Type = 36,
		R = 255, 
		G = 0, 
		B = 0,
		Size = 1.0,
	},

	ReceiptSell = {
		Pos = vector3(-1136.86, -199.96, 37.96),
		Type = 29,
		R = 0, 
		G = 255, 
		B = 0,
		Size = 1.0,
	},

}
Config.Garden = { 
	R = 186, 
	G = 12, 
	B = 0,
	Type = 2,
	Size = 1.0,
	vector3{ -1126.53, -211.17, 38.48},
	vector3{ -820.73, -61.67, 37.89},
	vector3{ 155.36, -18.69, 68.04},
	vector3{ -133.83, -429.32, 34.44},
}


for i=1, #Config.Garden, 1 do -- this is the marker for the gardens

	Config.Zones['Garden' .. i] = {
		Pos   = Config.Garden[i],
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 40, g = 169, b = 255},
		Type  = -1
	}

end

