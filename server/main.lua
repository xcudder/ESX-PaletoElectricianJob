ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("giveReward:paletoWorks")
AddEventHandler("giveReward:paletoWorks", function(reward)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addAccountMoney('money', reward)
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