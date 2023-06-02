RegisterCommand("set_max_speed", function(source, args)
	local metres_per_second = args[1] / 3.6
	vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
	SetVehicleMaxSpeed(vehicle, metres_per_second)
end, false)