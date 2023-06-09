local slots, data = {}, false
local possible_cars = Config.used_car_lot.cars
local buy_prompt = "Press ~INPUT_CONTEXT~ to buy this piece of junk for 12k"
local working, animated = false, false
local counter = 0

Citizen.CreateThread(function()
	v3 = vector3(-250.26, 6205.51, 30.49)
	while true do
		Wait(0)
		drawWorkMarker(v3)
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
	 end
end)

Citizen.CreateThread(function()
	while true do
		Wait(120000)
		if(working) then
			ESX.ShowNotification("You got 1 dolar")
			TriggerServerEvent("giveReward:paletoWorks", "misc", 1, 2)
		end
	end
end)

Citizen.CreateThread(function()
	setupBlip({
		title="Used Car Lot",
		colour=20, id=380,
		x=-246.04, y=6203.51, z=31.49
	})
end)

Citizen.CreateThread(function()
	Citizen.Wait(10000)
	while true do
		create_car(function(v) slots[1] = v end, vector3(-246.04, 6203.51, 31.49), 1)
		create_car(function(v) slots[2] = v end, vector3(-242.91, 6200.75, 31.49), 2)
		create_car(function(v) slots[3] = v end, vector3(-238.26, 6196.49, 31.49), 3)
		Citizen.Wait(20000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if entity_close_enough(slots[1], 3) then CarInteraction(slots[1]) end
		if entity_close_enough(slots[2], 3) then CarInteraction(slots[2]) end
		if entity_close_enough(slots[3], 3) then CarInteraction(slots[3]) end
	end
end)

function create_car(cb, v3, slot_index)
	Citizen.CreateThread(function()
		if not ESX.Game.IsSpawnPointClear(v3, 2) then
			if not slots[slot_index] then -- spawn point occupied but this client has no slot
				slots[slot_index] = ESX.Game.GetClosestVehicle(v3)
			end
			return
		end
		local car_hash = GetHashKey(possible_cars[math.random(#possible_cars)])
		ESX.Game.SpawnVehicle(car_hash, v3, 100.0, function(vehicle)
			SetVehicleDirtLevel(vehicle, 15.0)
			SetVehicleDoorsLocked(vehicle, 2)
			SetVehicleEngineHealth(vehicle, 700.0)
			SetVehicleMaxSpeed(vehicle, 17.0)
			cb(vehicle)
		end)
	end)
end

function CarInteraction(vehicle)
	DisplayHelpText(buy_prompt)
	if (IsControlJustReleased(1, 38)) then
		local vehprops = ESX.Game.GetVehicleProperties(vehicle)
		local plate =  exports['esx_vehicleshop']:GeneratePlate()

		ESX.TriggerServerCallback('used_car_lot:buyVehicle', function(success)
			if success then
				SetVehicleNumberPlateText(vehicle, plate)
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
				SetVehicleDoorsLocked(vehicle, 1)
			else
				ESX.ShowNotification(TranslateCap('not_enough_money'))
			end
		end, vehprops.model, plate)
	end
end