local slots, slot_prices, data = {}, {}, false
local possible_cars = Config.used_car_lot.cars
local working, animated = false, false
local counter = 0

-- Work
Citizen.CreateThread(function()
	local v3 = vector3(-250.26, 6205.51, 30.49)
	while true do
		Wait(0)

		if not working then drawWorkMarker(v3) end

		if(coordinates_close_enough(v3) and not working) then
			DisplayHelpText("Press ~INPUT_CONTEXT~ to start ~r~working")
			if animated then
				ClearPedTasksImmediately(PlayerPedId())
				animated = false
			end
			if(IsControlJustReleased(1, 38)) then
				working = true
			end
		else
			if(coordinates_close_enough(v3) and working) then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to stop ~r~working")
				if not animated then
					TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CAR_PARK_ATTENDANT", 0, true);
					SetEntityHeading(PlayerPedId(), 130.0)
					animated = true
				end
				if(IsControlJustReleased(1, 38)) then
					working = false
				end
			end
		end

		if not coordinates_close_enough(v3) and working then -- don't cancel animation and leave
			working = false
		end
	end
end)

-- Work Rewards
Citizen.CreateThread(function()
	while true do
		Wait(120000)

		if(working) then
			ESX.ShowNotification("You got 1 dolar")
			TriggerServerEvent("giveReward:paletoLives", 1, "misc", 2)
		end
	end
end)

-- Blip
Citizen.CreateThread(function()
	setupBlip({
		title="Used Car Lot",
		colour=20, id=380,
		v3=vector3(-246.04, 6203.51, 31.49)
	})
end)

-- Continously create cars
Citizen.CreateThread(function()
	while true do
		slots[1] = CreateCar(vector3(-246.04, 6203.51, 31.49), 1)
		slots[2] = CreateCar(vector3(-242.91, 6200.75, 31.49), 2)
		slots[3] = CreateCar(vector3(-238.26, 6196.49, 31.49), 3)

		Citizen.Wait(20000)
	end
end)

-- Continously check for purchase proximity
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if coordinates_close_enough(vector3(-246.04, 6203.51, 31.49), 3) then CarInteraction(slots[1], slot_prices[1], 1) end
		if coordinates_close_enough(vector3(-242.91, 6200.75, 31.49), 3) then CarInteraction(slots[2], slot_prices[2], 2) end
		if coordinates_close_enough(vector3(-238.26, 6196.49, 31.49), 3) then CarInteraction(slots[3], slot_prices[3], 3) end
	end
end)

function BangUpTheCar(vehicle)
	SetEntityHeading(vehicle, 131.40)
	SetVehicleDirtLevel(vehicle, 15.0)
	SetVehicleDoorsLocked(vehicle, 2)
	SetVehicleEngineHealth(vehicle, 700.0)
	SetVehicleMaxSpeed(vehicle, 17.0)
end

function CreateCar(v3, slot_index)
	local picked_car = {}

	Citizen.CreateThread(function()
		if not ESX.Game.IsSpawnPointClear(v3, 2) then return end

		picked_car 	= possible_cars[math.random(#possible_cars)]

		local car_hash 		= GetHashKey(picked_car.name)
		local vehicle

		slot_prices[slot_index] = math.random(picked_car.min, picked_car.max)

		while not HasModelLoaded(car_hash) do
			RequestModel(car_hash)
			Wait(100)
		end

		CreateVehicle(car_hash, v3, 131.40, false)
	end)
	while not picked_car.name do Wait(100) end
	return picked_car.name
end

function CarInteraction(vehicle_name, price, slot_index)
	DisplayHelpText("Press ~INPUT_CONTEXT~ to buy this piece of junk for... say...$" .. price)
	if (IsControlJustReleased(1, 38)) then
		local persistent_vehicle = false
		local plate =  exports['esx_vehicleshop']:GeneratePlate()

		ESX.TriggerServerCallback('used_car_lot:buyVehicle', function(success)
			local exit_coords = vector3(-235.89, 6184.82, 31.49)

			if success then
				slots[slot_index], slot_prices[slot_index] = '', 0

				ESX.Game.SpawnVehicle(GetHashKey(vehicle_name), exit_coords, 100.0, function(vehicle)
					persistent_vehicle = vehicle
				end, true)

				while not persistent_vehicle do Wait(100) end

				BangUpTheCar(persistent_vehicle)
				SetEntityHeading(persistent_vehicle, 131.40)
				SetVehicleNumberPlateText(persistent_vehicle, plate)
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), persistent_vehicle, -1)
				SetVehicleDoorsLocked(persistent_vehicle, 1)
			else
				ESX.ShowNotification(TranslateCap('not_enough_money'))
			end
		end, GetHashKey(vehicle_name), price, plate)
	end
end