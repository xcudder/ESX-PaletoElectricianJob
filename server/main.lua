ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("giveReward:paletoWorks")
AddEventHandler("giveReward:paletoWorks", function(reward)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addAccountMoney('money', reward)
end)


RegisterNetEvent('toggleJob:paletoWorks')
AddEventHandler('toggleJob:paletoWorks', function(start, job_name)
  local xPlayer = ESX.GetPlayerFromId(source)
  local job = start and job_name or 'unemployed'

  if xPlayer then
    if ESX.DoesJobExist(job_name, 0) or job == 'unemployed' then
      xPlayer.setJob(job , 0)
  	end
  end
end)
