ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("giveReward:paletoLives")
AddEventHandler("giveReward:paletoLives", function(reward, job_name, work_points)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addAccountMoney('money', reward)

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = ?', {xPlayer.identifier}, function(result)
		if result == nil or #result == 0 then return end
		local user = result[1]

		local jobs, correct_job
		local previous_job = false

		if user.work_experience ~= nil and #json.decode(user.work_experience) > 0 then
			jobs = json.decode(user.work_experience)
			for i=1, #jobs, 1 do
				if(jobs[i].job_name == job_name) then
					previous_job = true
					jobs[i].work_points = jobs[i].work_points + work_points
				end
			end
		else
			jobs = {{job_name = job_name, work_points = work_points}}
		end

		if not previous_job then
			jobs[#jobs + 1] = {job_name = job_name, work_points = work_points}
		end

		MySQL.update('UPDATE users SET work_experience = @jobs WHERE identifier = @identifier', {
			['@jobs'] = json.encode(jobs),
			['@identifier'] = xPlayer.identifier
		})
	end)
end)

RegisterNetEvent('toggleJob:paletoLives')
AddEventHandler('toggleJob:paletoLives', function(job_name, job_specific_points)
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = 0

	if job_name == 'electrician' and job_specific_points >= 4000 then grade = 1 end

	if xPlayer and ESX.DoesJobExist(job_name, grade) then xPlayer.setJob(job_name, grade) end
end)

ESX.RegisterServerCallback('getProperties:paletoLives', function(source, cb)
	local PropertiesList = LoadResourceFile('esx_property', 'properties.json')
	if PropertiesList then cb(PropertiesList) end
end)

ESX.RegisterServerCallback('getWorkExperience:paletoLives', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local users = MySQL.query.await('SELECT * FROM users WHERE identifier = ?', {xPlayer.identifier})
	cb(json.decode(users[1].work_experience))
end)

RegisterNetEvent('enterProperty:paletoLives')
AddEventHandler('enterProperty:paletoLives', function(interiorType, outside)
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

ESX.RegisterServerCallback("payForLunch:paletoLives", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= 8 then
		xPlayer.removeMoney(8, "Lunch")
		cb(true)
	else
		cb(false)
	end
end)