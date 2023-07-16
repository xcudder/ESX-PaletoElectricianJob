local LunchSpotAvailable = false
local LunchSpotBlip = false
local PlayerIsValidPaletoWorker = false
local job_specific_points = 0
local v3 = vector3(-123.28, 6390.1, 32.18)
local PlayerData = {}
local lastAte = -1

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	if PlayerData.job.name == 'electrician' or PlayerData.job.name ==  'factory_helper' or PlayerData.job.name == 'cleaner' then
		job_specific_points = get_player_work_experience('job', PlayerData.job.name)
		PlayerIsValidPaletoWorker = true
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job

	if PlayerData.job.name == 'electrician' or PlayerData.job.name ==  'factory_helper' or PlayerData.job.name == 'cleaner' then
		job_specific_points = get_player_work_experience('job', job.name)
		PlayerIsValidPaletoWorker = true
	end
end)

Citizen.CreateThread(function()
	LunchSpotBlip = setupBlip({
		title="Worker Lunch Spot",
		colour=46, id=77, v3=v3
	})

	while true do
		Wait(1000)
		LunchSpotAvailable = (GetClockHours() <= 14 and GetClockHours() >= 11)
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		
		DrawMarker(0, v3.x, v3.y, v3.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 244, 244, 23, 100, true, true, 2, true, false, false, false)

		if coordinates_close_enough(v3) then
			if not LunchSpotAvailable then
				DisplayHelpText("Our restaurant is closed (11:00 to 14:00)")
			elseif not PlayerIsValidPaletoWorker then
				DisplayHelpText("Our restaurant is open to local workers only")
			elseif lastAte == GetClockDayOfWeek()  then
				DisplayHelpText("One meal per day, sir")
			elseif job_specific_points < 1500 then
				DisplayHelpText("You need another " .. (1500 - job_specific_points) .. " work points in your job to eat here")
			else
				DisplayHelpText("Press ~INPUT_CONTEXT~ to pay 8 bucks for ~y~lunch")
				if(IsControlJustReleased(1, 38)) then
					ESX.TriggerServerCallback("payForLunch:paletoLives", function(lunchPayedFor)
						if (lunchPayedFor) then
							lastAte = GetClockDayOfWeek()
							DoScreenFadeOut(1000)
							Wait(3000)
							TriggerEvent("esx_status:add", 'hunger', 200000)
							TriggerEvent("esx_status:add", 'thirst', 200000)
							DoScreenFadeIn(1000)
						else
							ESX.ShowNotification("Couldn't pay")
						end
					end)
				end
			end
		end
	end
end)