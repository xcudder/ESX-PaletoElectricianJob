local PlayerData = {}

--counters
local points_worked_on = 0
local reward = 0

-- boilerplating
local quest_giver = false
local local_cfg = Config.paleto_electrician

-- randow work temp storage
local random_work_position_blip = false
local random_work_position = {}
local isWorking = false

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	if PlayerData.job and PlayerData.job.name == 'electrician' then
		putUniformOn(local_cfg.Clothes)
		generate_new_work_order(local_cfg, random_work_position_blip, function(new_work, new_blip)
			random_work_position = new_work
			random_work_position_blip = new_blip
		end)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	if PlayerData.job and PlayerData.job.name ~= 'electrician' then
		RemoveBlip(random_work_position_blip)
	else
		putUniformOn(local_cfg.Clothes)
		generate_new_work_order(local_cfg, random_work_position_blip, function(new_work, new_blip)
			random_work_position = new_work
			random_work_position_blip = new_blip
		end)
	end
end)

-- One time setup
Citizen.CreateThread(function()
	quest_giver = create_task_giver(local_cfg, "WORLD_HUMAN_SMOKING")
	setupBlip({
		title="Power Plant #1",
		colour=0, id=620,
		x=local_cfg.QuestGiver.NPCXAxis,
		y=local_cfg.QuestGiver.NPCYAxis,
		z=local_cfg.QuestGiver.NPCZAxis
	})
end)

-- Continuous check of quest-giver-proximity based logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		while not quest_giver do
			Wait(1)
		end

		 if entity_close_enough(quest_giver) then
			if PlayerData.job and PlayerData.job.name ~= 'electrician' then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to start the job")
				if(IsControlJustReleased(1, 38))then TriggerServerEvent('toggleJob:paletoWorks', 'electrician') end
			else
				DisplayHelpText("Press ~INPUT_CONTEXT~ to stop the job")
				if(IsControlJustReleased(1, 38))then stop_work('electrician', points_worked_on, 4) end
			end
		end
	end
end)

-- continuous check of random work position logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if PlayerData.job and PlayerData.job.name == 'electrician' then
			drawWorkMarker(random_work_position)
			if display_work_cta(isWorking, random_work_position) then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to ~r~working")
				if(IsControlJustReleased(1, 38)) then electrician_working() end
			end
		end
	end
end)

-- Job specific block of logic
function electrician_working()
	isWorking = true
	Citizen.CreateThread(function()
		Citizen.Wait(10)
		run_work_animations('electrician', random_work_position, GetPlayerPed(-1))
		isWorking = false
		generate_new_work_order(local_cfg, random_work_position_blip, function(new_work, new_blip)
			random_work_position = new_work
			random_work_position_blip = new_blip
		end)
		points_worked_on = points_worked_on + 1
		communicate_job_progression('Electrician', points_worked_on, 4)
	end)
end