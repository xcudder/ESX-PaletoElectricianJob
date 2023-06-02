RegisterCommand("teleport", function(source, a)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.setCoords(vector3(tonumber(a[1]), tonumber(a[2]), tonumber(a[3])))
    ---1.34 6432.75 30.43
end, true)