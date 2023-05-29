local PlayerData = {}

local isWorking = false

local master_electrictian = false

local random_work_position = Config.WorkPoints[math.random(#Config.WorkPoints)]

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


-- Create blips
local blips = {
	{title="Power Plant #1", colour=0, id=354, x=-285.38, y=6029.76, z=31.5},
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.9)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
    end
end)

-- Future quest giver
Citizen.CreateThread(function()
	RequestModel(Config.NPCHash)
	
	while not HasModelLoaded(Config.NPCHash) do
		Wait(1)
	end

	master_electrictian = CreatePed(1, Config.NPCHash, -285.38, 6029.76, Config.NPCZAxis, 60, false, true)
	SetBlockingOfNonTemporaryEvents(master_electrictian, true)
	SetPedDiesWhenInjured(master_electrictian, false)
	SetPedCanPlayAmbientAnims(master_electrictian, true)
	SetPedCanRagdollFromPlayerImpact(master_electrictian, false)
	SetEntityInvincible(master_electrictian, true)
	FreezeEntityPosition(master_electrictian, true)
	TaskStartScenarioInPlace(master_electrictian, "WORLD_HUMAN_SMOKING", 0, true);
end)

-- Start/Stop Job
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		while not master_electrictian do
			Wait(1)
		end

		local A = GetEntityCoords(GetPlayerPed(-1), false)
		local B = GetEntityCoords(master_electrictian, false)
		if Vdist(B.x, B.y, B.z, A.x, A.y, A.z) < 1.5 then
			if PlayerData.job and PlayerData.job.name ~= 'electrician' then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to start the job")

				if(IsControlJustReleased(1, 38))then
					TriggerServerEvent('toggleJob:electricianJob', true)
					putUniformOn()
				end
			else
				DisplayHelpText("Press ~INPUT_CONTEXT~ to stop the job")

				if(IsControlJustReleased(1, 38))then
					TriggerServerEvent('toggleJob:electricianJob', false)
					getOutOfUniform()
				end
			end
		end
	end
end)

-- Random task logics
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if PlayerData.job and PlayerData.job.name == 'electrician' then
			local player_position = GetEntityCoords(GetPlayerPed(-1), false)
			local work_player_distance = Vdist(random_work_position.x, random_work_position.y, random_work_position.z, player_position.x, player_position.y, player_position.z)

			DrawMarker(1, random_work_position.x, random_work_position.y, random_work_position.z,0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 155, 0, 0, 2, 0, 0, 0, 0)

			if work_player_distance < 1.5 then
				if isWorking == false then
					DisplayHelpText("Press ~INPUT_CONTEXT~ to ~r~working")

					if(IsControlJustReleased(1, 38)) then
						working()
					end
				end
			end
		end
	end
end)

function putUniformOn()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
	    if skin.sex == 0 then
	        TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes.male)
	    elseif skin.sex == 1 then
	        TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes.female)
	    end
    end)
end

function getOutOfUniform()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
    	TriggerEvent('skinchanger:loadSkin', skin)
    end)
end

function working()
	local playerPed = GetPlayerPed(-1)
	isWorking = true
    Citizen.CreateThread(function()
        Citizen.Wait(10)
		TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
		Wait(10000)
        TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_POLICE_INVESTIGATE", 0, true)
		Wait(10000)
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
        Wait(10000)
        ClearPedTasksImmediately(playerPed)
		TriggerServerEvent("addItems:electricianJob")
        random_work_position = Config.WorkPoints[math.random(#Config.WorkPoints)]
        TriggerEvent('notifications', "#29c501", "Electrician", "You've got 2 bucks")
    	isWorking = false
    end)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
