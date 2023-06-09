ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("giveReward:paletoWorks")
AddEventHandler("giveReward:paletoWorks", function(reward, job_name, work_points)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addAccountMoney('money', reward)

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = ?', {xPlayer.identifier}, function(result)
		if result == nil or #result == 0 then return end
		result = result[1]

		local jobs, correct_job

		if result.work_experience ~= nil and #result.work_experience > 0 then
			jobs = json.decode(result.work_experience)
			for i=1, #jobs, 1 do
				if(jobs[i].job_name == job_name) then
					jobs[i].work_points = jobs[i].work_points + work_points
				end
			end
		else
			jobs = {{job_name = job_name, work_points = work_points}}
		end

		MySQL.update('UPDATE users SET work_experience = @jobs WHERE identifier = @identifier', {
			['@jobs'] = json.encode(jobs),
			['@identifier'] = xPlayer.identifier
		})
	end)
end)


RegisterNetEvent('toggleJob:paletoWorks')
AddEventHandler('toggleJob:paletoWorks', function(job_name)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer and ESX.DoesJobExist(job_name, 0) then xPlayer.setJob(job_name , 0) end
end)

ESX.RegisterServerCallback('getProperties:paletoWorks', function(source, cb)
	local PropertiesList = LoadResourceFile('esx_property', 'properties.json')
	if PropertiesList then cb(PropertiesList) end
end)

RegisterNetEvent('enterProperty:paletoWorks')
AddEventHandler('enterProperty:paletoWorks', function(interiorType, outside)
	local xPlayer = ESX.GetPlayerFromId(source)
	local x, y, z

	if interiorType == 'low-end' then
		x, y, z = 266.1, -1007.23, -101.01
	elseif interiorType == 'mid-end' then
		x, y, z = 346.81, -1012.83, -99.2
	elseif outside then
		x, y, z = outside.x, outside.y, outside.z
	else
		x, y, z = 1.68, 6427.31, 30.43 --something went wrong, go to the quest giver
	end

	xPlayer.setCoords(vector3(x, y, z))
end)