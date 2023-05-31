function putUniformOn(clothes_config)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
	    if skin.sex == 0 then
	        TriggerEvent('skinchanger:loadClothes', skin, clothes_config.male)
	    elseif skin.sex == 1 then
	        TriggerEvent('skinchanger:loadClothes', skin, clothes_config.Clothes.female)
	    end
    end)
end

function getOutOfUniform()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
    	TriggerEvent('skinchanger:loadSkin', skin)
    end)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end