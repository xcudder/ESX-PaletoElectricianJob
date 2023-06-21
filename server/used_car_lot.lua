ESX.RegisterServerCallback('used_car_lot:buyVehicle', function(source, cb, model, price, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price, "Vehicle Purchase")
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