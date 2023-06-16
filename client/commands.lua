RegisterCommand("set_max_speed", function(source, args)
	local metres_per_second = args[1] / 3.6
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
	SetVehicleMaxSpeed(vehicle, metres_per_second)
end, false)

RegisterCommand("time", function(source, args)
	local hours 			= GetClockHours()
	local minutes 			= GetClockMinutes()
	local day_of_the_week 	= GetClockDayOfWeek()
	local day = ""

	if day_of_the_week == 0 then day = "Sunday" end
	if day_of_the_week == 1 then day = "Monday" end
	if day_of_the_week == 2 then day = "Tuesday" end
	if day_of_the_week == 3 then day = "Wednesday" end
	if day_of_the_week == 4 then day = "Thursday" end
	if day_of_the_week == 5 then day = "Friday" end
	if day_of_the_week == 6 then day = "Saturday" end

	ESX.ShowNotification( day .. ", month: " .. GetClockMonth() .. ", " .. GetClockHours() .. ":" .. GetClockMinutes())

end, false)

RegisterCommand("get_heading", function(source, args)
	local pped = PlayerPedId()
	local heading = GetEntityHeading(pped)
	ESX.ShowNotification("Heading : " .. heading)
end, false)