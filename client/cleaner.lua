local PlayerData = {}

local isWorking = false

local quest_giver = false

local points_worked_on = 0

local reward = 0

local random_work_position_blip = false
local random_work_position = {}

ESX = exports["es_extended"]:getSharedObject()

-- RegisterNetEvent('esx:playerLoaded')
-- AddEventHandler('esx:playerLoaded', function(xPlayer)
--   	PlayerData = xPlayer
--   	if PlayerData.job and PlayerData.job.name == 'cleaner' then
--   		putUniformOn(Config.paleto_cleaner.Clothes)
--   		generate_new_work_order(Config.paleto_cleaner, random_work_position_blip, function(new_work, new_blip)
-- 			random_work_position = new_work
-- 			random_work_position_blip = new_blip
-- 		end)
--   	end
-- end)

-- RegisterNetEvent('esx:setJob')
-- AddEventHandler('esx:setJob', function(job)
-- 	PlayerData.job = job
-- 	if PlayerData.job and PlayerData.job.name ~= 'cleaner' then
-- 		RemoveBlip(random_work_position_blip)
-- 	else
-- 		putUniformOn(Config.paleto_cleaner.Clothes)
-- 		generate_new_work_order(Config.paleto_cleaner, random_work_position_blip, function(new_work, new_blip)
-- 			random_work_position = new_work
-- 			random_work_position_blip = new_blip
-- 		end)
-- 	end
-- end)

-- One time setup
Citizen.CreateThread(function()
	create_task_giver(Config.paleto_cleaner, "WORLD_HUMAN_SMOKING")
    setupBlip({
		title="Cleaning Service",
		colour=0, id=837,
		x=Config.paleto_cleaner.QuestGiver.NPCXAxis8,
		y=Config.paleto_cleaner.QuestGiver.NPCYAxis,
		z=Config.paleto_cleaner.QuestGiver.NPCZAxis
	})
end)

-- -- Continuous check of quest-giver-proximity based logic
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(1)

-- 		while not quest_giver do
-- 			Wait(1)
-- 		end

-- 		 if offer_job(quest_giver) then
-- 			if PlayerData.job and PlayerData.job.name ~= 'cleaner' then
-- 				DisplayHelpText("Press ~INPUT_CONTEXT~ to start the job")
-- 				if(IsControlJustReleased(1, 38))then TriggerServerEvent('toggleJob:paletoWorks', true, 'cleaner') end
-- 			else
-- 				DisplayHelpText("Press ~INPUT_CONTEXT~ to stop the job")
-- 			end
-- 		end
-- 	end
-- end)

-- -- Continuous check of random work position logic
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(1)
-- 		if PlayerData.job and PlayerData.job.name == 'cleaner' then
-- 			drawWorkMarker(random_work_position)
-- 			if display_work_cta(isWorking, random_work_position) then
-- 				DisplayHelpText("Press ~INPUT_CONTEXT~ to ~r~working")
-- 				if(IsControlJustReleased(1, 38)) then cleaner_working() end
-- 			end
-- 		end
-- 	end
-- end)

-- -- Job specific block of logic
-- function cleaner_working()
-- 	isWorking = true
--     Citizen.CreateThread(function()
--         Citizen.Wait(10)
-- 		run_work_animations('cleaner', random_work_position, GetPlayerPed(-1))
-- 		generate_new_work_order(Config.paleto_cleaner, random_work_position_blip, function(new_work, new_blip)
-- 			random_work_position = new_work
-- 			random_work_position_blip = new_blip
-- 		end)
--         points_worked_on = points_worked_on + 1
--        	communicate_cleaner_progression('Cleaner', points_worked_on, 4)
--     	isWorking = false
--     end)
-- end