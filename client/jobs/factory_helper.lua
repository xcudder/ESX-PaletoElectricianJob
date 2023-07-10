local PlayerData = {}

--counters
local points_worked_on = 0

-- boilerplating
local quest_giver = false
local local_cfg = Config.paleto_factory_helper

-- randow work temp storage
local random_work_position_blip = false
local random_work_position = {}
local isWorking = false

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	if PlayerData.job and PlayerData.job.name == 'factory_helper' then
		PlayerData.factory_points = get_player_work_experience('job',PlayerData.job.name)
		PlayerData.factory_points = PlayerData.factory_points + get_player_skill_experience('information_technology')

		putUniformOn(local_cfg.Clothes[PlayerData.job.grade + 1])
		generate_new_work_order(local_cfg, random_work_position_blip, function(new_work, new_blip)
			random_work_position = new_work
			random_work_position_blip = new_blip
		end)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job

	if PlayerData.job and PlayerData.job.name ~= 'factory_helper' then
		points_worked_on = 0
		if DoesBlipExist(random_work_position_blip) then
			RemoveBlip(random_work_position_blip)
		end
	else
		PlayerData.factory_points = get_player_work_experience('job',job.name)
		PlayerData.factory_points = PlayerData.factory_points + get_player_skill_experience('information_technology')

		putUniformOn(local_cfg.Clothes[job.grade + 1])
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
		title="Meat Factory",
		colour=9, id=801,
		v3=local_cfg.QuestGiver
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
			if PlayerData.job and PlayerData.job.name ~= 'factory_helper' then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to start the job")
				if(IsControlJustReleased(1, 38))then start_work('factory_helper', 550) end
			else
				DisplayHelpText("Press ~INPUT_CONTEXT~ to stop the job")
				if(IsControlJustReleased(1, 38))then stop_work('factory_helper', points_worked_on, 3) end
			end
		end
	end
end)

-- continuous check of random work position logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if PlayerData.job and PlayerData.job.name == 'factory_helper' then
			drawWorkMarker(random_work_position)
			if display_work_cta(isWorking, random_work_position) then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to ~r~working")
				if(IsControlJustReleased(1, 38)) then factory_helper_working() end
			end
		end
	end
end)

-- Job specific block of logic
function factory_helper_working()
	isWorking = true
	Citizen.CreateThread(function()
		Citizen.Wait(10)
		run_factory_helper_animation(random_work_position, PlayerData.factory_points)
		isWorking = false
		generate_new_work_order(local_cfg, random_work_position_blip, function(new_work, new_blip)
			random_work_position = new_work
			random_work_position_blip = new_blip
		end)
		points_worked_on = points_worked_on + 1
		trigger_job_progression('factory_helper', points_worked_on, 4)
	end)
end

function run_factory_helper_animation(work_position, workPoints)
	setPlayerAtWorkPosition(work_position)

	local computer_work_animation_time = 10000 - workPoints
	local clipboard_work_animation_time = 15000 - workPoints
	local playerPed = PlayerPedId()

	if work_position.type == 'computer' then
		RequestAnimDict("abigail_mcs_1_concat-9")
		Citizen.Wait(100)
		Citizen.CreateThread(function()
			TaskPlayAnim(playerPed, 'abigail_mcs_1_concat-9', 'csb_abigail_dual-9', 12.0, 12.0, computer_work_animation_time, 81, 0.0, 1, 1, 1)
			SetEntityHeading(playerPed, 375.0)
		end)
		Wait(computer_work_animation_time)
		RemoveAnimDict("abigail_mcs_1_concat-9")
	else
		TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
		Wait(clipboard_work_animation_time)
		ClearPedTasksImmediately(playerPed)
		delete_object(`p_cs_clipboard`)
	end
end