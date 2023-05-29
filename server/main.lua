ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("addItems:electricianJob")
AddEventHandler("addItems:electricianJob", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addAccountMoney('bank', 2)
end)


RegisterNetEvent('toggleJob:electricianJob')
AddEventHandler('toggleJob:electricianJob', function(start)
  local xPlayer = ESX.GetPlayerFromId(source)
  local job = start and 'electrician' or 'unemployed'

  if xPlayer then
    if ESX.DoesJobExist('electrician', 0) then
      xPlayer.setJob(job , 0)
  	end
  end
end)
