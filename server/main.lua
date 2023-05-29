ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("addItems:electricianJob")
AddEventHandler("addItems:electricianJob", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addAccountMoney('bank', 2)
end)