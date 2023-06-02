RegisterCommand("teleport", function(source, a)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.setCoords(vector3(tonumber(a[1]), tonumber(a[2]), tonumber(a[3])))
end, true)