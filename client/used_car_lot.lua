local l1, l2, l3, data = false, false, false, false
local possible_cars = Config.used_car_lot.cars

Citizen.CreateThread(function()
	setupBlip({
		title="Used Car Lot",
		colour=20, id=380,
		x=-246.04, y=6203.51, z=31.49
	})
end)

Citizen.CreateThread(function()
	create_car(function(v) l1 = v end, vector3(-246.04, 6203.51, 31.49))
	create_car(function(v) l2 = v end, vector3(-242.91, 6200.75, 31.49))
	create_car(function(v) l3 = v end, vector3(-238.26, 6196.49, 31.49))
end)

function load_car(data, cb)
	ESX.Game.SpawnVehicle(data.car, data.v3, 100.0, function(vehicle)
	    SetVehicleDoorsLocked(vehicle, 2)
	    cb(vehicle)
	end)
end

function create_car(cb, v3)
	local car_hash = GetHashKey(possible_cars[math.random(#possible_cars)])
	-- ESX.Game.SpawnVehicle(car_hash, v3, 100.0, function(vehicle) cb = vehicle end) 
	ESX.Game.SpawnLocalVehicle(car_hash, v3, 100.0, function(vehicle) cb = vehicle end) 
end