local days = {
	0 = "Sunday",
	1 = "Monday",
	2 = "Tuesday",
	3 = "Wednesday",
	4 = "Thursday",
	5 = "Friday",
	6 = "Saturday"
}

RegisterCommand("set_max_speed", function(source, args)
	local metres_per_second = args[1] / 3.6
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
	SetVehicleMaxSpeed(vehicle, metres_per_second)
end, false)

RegisterCommand("time", function(source, args)
	local day_of_the_week = GetClockDayOfWeek()
	day_of_the_week = days[day_of_the_week]
	local hours = GetClockHours()
	local minutes = GetClockMinutes()
	ESX.ShowNotification( days_of_the_week .. "," .. GetClockMonth() .. "," .. GetClockHours() .. ":" .. GetClockMinutes())
end, false)

RegisterCommand("get_heading", function(source, args)
	local pped = PlayerPedId()
	local heading = GetEntityHeading(pped)
	ESX.ShowNotification("Heading : " .. heading)
end, false)