local slots, data = {}, false
local possible_cars = Config.used_car_lot.cars
local buy_prompt = "Press ~INPUT_CONTEXT~ to buy this piece of junk"

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
				ESX.ShowNotification("That thing happened...")
			end
			return
		end
		local car_hash = GetHashKey(possible_cars[math.random(#possible_cars)])
		ESX.Game.SpawnVehicle(car_hash, v3, 100.0, function(vehicle)
			SetVehicleDoorsLocked(vehicle, 2)
			cb(vehicle)
		end)
	end)
end

function CarInteraction(vehicle)
	DisplayHelpText(buy_prompt)
	if(IsControlJustReleased(1, 38)) then
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
	end
end