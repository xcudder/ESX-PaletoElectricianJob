local PlayerData = {}

local isWorking = false

local quest_giver = false

local points_worked_on = 0

local reward = 0

local random_work_position_blip = false

local random_work_position = {}

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	PlayerData = xPlayer
  	if PlayerData.job and PlayerData.job.name == 'factory_helper' then
  		putUniformOn()
		random_work_position 		= Config.paleto_factory_helper.WorkPoints[math.random(#Config.paleto_factory_helper.WorkPoints)]
		random_work_position_blip 	= AddBlipForCoord(random_work_position.x, random_work_position.y, random_work_position.z)

		ClearAreaOfPeds(random_work_position.x, random_work_position.y, 30.9, 2.5, 1)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  	PlayerData.job = job
end)

-- Create blips
local blips = {
	{title="Paleto Meat Factory", colour=0, id=791, x=-73.09, y=6266.76, z=30.26},
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
	RequestModel(Config.paleto_factory_helper.NPCHash)
	
	while not HasModelLoaded(Config.paleto_factory_helper.NPCHash) do
		Wait(1)
	end

	quest_giver = CreatePed(1, Config.paleto_factory_helper.NPCHash, -73.09, 6266.6, Config.paleto_factory_helper.NPCZAxis, 60, false, true)
	SetBlockingOfNonTemporaryEvents(quest_giver, true)
	SetPedDiesWhenInjured(quest_giver, false)
	SetPedCanPlayAmbientAnims(quest_giver, true)
	SetPedCanRagdollFromPlayerImpact(quest_giver, false)
	SetEntityInvincible(quest_giver, true)
	FreezeEntityPosition(quest_giver, true)
	TaskStartScenarioInPlace(quest_giver, "WORLD_HUMAN_CLIPBOARD", 0, true);
end)

-- Start/Stop Job
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		while not quest_giver do
			Wait(1)
		end

		local A = GetEntityCoords(GetPlayerPed(-1), false)
		local B = GetEntityCoords(quest_giver, false)
		if Vdist(B.x, B.y, B.z, A.x, A.y, A.z) < 1.5 then
			if PlayerData.job and PlayerData.job.name ~= 'factory_helper' then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to start the job")

				if(IsControlJustReleased(1, 38))then
					TriggerServerEvent('toggleJob:paletoWorks', true, 'factory_helper')
					putUniformOn()
				end
			else
				DisplayHelpText("Press ~INPUT_CONTEXT~ to stop the job")

				if(IsControlJustReleased(1, 38))then
					TriggerServerEvent('toggleJob:paletoWorks', false, '')
					getOutOfUniform()
					reward = math.floor(points_worked_on / 3)
					TriggerEvent('notifications', "#29c501", "Worker", "You've become ".. reward .."$ richer")
					TriggerServerEvent("giveReward:paletoWorks", reward)
				end
			end
		end
	end
end)

-- Random task logics
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if PlayerData.job and PlayerData.job.name == 'factory_helper' then
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
	        TriggerEvent('skinchanger:loadClothes', skin, Config.paleto_factory_helper.Clothes.male)
	    elseif skin.sex == 1 then
	        TriggerEvent('skinchanger:loadClothes', skin, Config.paleto_factory_helper.Clothes.female)
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

        if random_work_position.type == 'computer' then
        	local ped = PlayerPedId()
			RequestAnimDict("amb@prop_human_seat_computer@male@base")
            Citizen.Wait(100)
            TaskPlayAnim((ped), "amb@prop_human_seat_computer@male@base", 'base', 12.0, 12.0, -1, 80, 0, 0, 0, 0)
            -- SetEntityHeading(ped, 270.0)
			Wait(30000)
        else
			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
			Wait(30000)
        end

        ClearPedTasksImmediately(playerPed)
        
        RemoveBlip(random_work_position_blip)
        random_work_position = Config.paleto_factory_helper.WorkPoints[math.random(#Config.paleto_factory_helper.WorkPoints)]
		random_work_position_blip = AddBlipForCoord(random_work_position.x, random_work_position.y, 0)

        ClearAreaOfPeds(random_work_position.x, random_work_position.y, 30.9, 2.5, 1)
        
        points_worked_on = points_worked_on + 1
        if  math.fmod(points_worked_on, 4) == 0 then
        	TriggerEvent('notifications', "#29c501", "Worker", "You've worked a total of "..points_worked_on.." points")
    	end
    	isWorking = false
    end)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
