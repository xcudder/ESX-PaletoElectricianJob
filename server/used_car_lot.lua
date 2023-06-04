ESX.RegisterServerCallback('used_car_lot:buyVehicle', function(source, cb, model, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= 12000 then
		xPlayer.removeMoney(12000, "Vehicle Purchase")
		MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?, ?, ?)', {
			xPlayer.identifier, plate, json.encode({
				model = model,
				plate = plate
			})
		}, function(rowsChanged)
			cb(true)
		end)
	else
		cb(false)
	end
end)