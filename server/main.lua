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
