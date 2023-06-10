RegisterCommand("set_max_speed", function(source, args)
	local metres_per_second = args[1] / 3.6
	vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
	SetVehicleMaxSpeed(vehicle, metres_per_second)
end, false)

RegisterCommand("time", function(source, args)
	hours = GetClockHours()
	minutes = GetClockMinutes()
	ESX.ShowNotification(GetClockHours() .. ":" .. GetClockMinutes())
end, false)

RegisterCommand("get_heading", function(source, args)
	local pped = PlayerPedId()
	local heading = GetEntityHeading(pped)
	ESX.ShowNotification("Heading : " .. heading)
end, false)