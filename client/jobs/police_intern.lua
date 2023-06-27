local PlayerData = {}

--counters
local points_worked_on = 0

-- boilerplating
local quest_giver = false
local local_cfg = Config.paleto_police_intern

-- randow work temp storage
local random_work_position_blip = false
local random_work_position = {}
local isWorking = false

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	if PlayerData.job and PlayerData.job.name == 'police_intern' then
		PlayerData.police_intern_points = get_player_work_experience('job',PlayerData.job.name)
		PlayerData.police_intern_points = PlayerData.police_intern_points + get_player_skill_experience('law')

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

	if PlayerData.job and PlayerData.job.name ~= 'police_intern' then
		points_worked_on = 0
		if DoesBlipExist(random_work_position_blip) then
			RemoveBlip(random_work_position_blip)
		end
	else
		PlayerData.police_intern_points = get_player_work_experience('job',job.name)
		PlayerData.police_intern_points = PlayerData.police_intern_points + get_player_skill_experience('law')

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
		title="Paleto Police",
		colour=46, id=526,
		x=local_cfg.QuestGiver.x,
		y=local_cfg.QuestGiver.y,
		z=local_cfg.QuestGiver.z
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
			if PlayerData.job and PlayerData.job.name ~= 'police_intern' then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to start the job")
				if(IsControlJustReleased(1, 38))then start_work('police_intern', 300) end
			else
				DisplayHelpText("Press ~INPUT_CONTEXT~ to stop the job")
				if(IsControlJustReleased(1, 38))then stop_work('police_intern', points_worked_on, 10) end
			end
		end
	end
end)

-- continuous check of random work position logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if PlayerData.job and PlayerData.job.name == 'police_intern' then
			drawWorkMarker(random_work_position)
			if display_work_cta(isWorking, random_work_position) then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to ~r~working")
				if(IsControlJustReleased(1, 38)) then police_intern_working() end
			end
		end
	end
end)

-- Job specific block of logic
function police_intern_working()
	isWorking = true
	Citizen.CreateThread(function()
		Citizen.Wait(10)
		run_intern_animation('police_intern', random_work_position, PlayerData.police_intern_points)
		isWorking = false
		generate_new_work_order(local_cfg, random_work_position_blip, function(new_work, new_blip)
			random_work_position = new_work
			random_work_position_blip = new_blip
		end)
		points_worked_on = points_worked_on + 1
		trigger_job_progression('police_intern', points_worked_on, 10)
	end)
end

function run_intern_animation(work_position, workPoints)
	setPlayerAtWorkPosition(work_position)

	local playerPed = PlayerPedId()
	local clipboard_work_animation_time = 15000 - workPoints
	local digitalizing_work_animation_time = 5000 - workPoints

	if work_position.type == 'coffee' then
		TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_AA_COFFEE", work_position.heading, true)
		Wait(10000)
		TriggerEvent("esx_status:remove", 'sleepiness', 20000)
		TriggerEvent("esx_status:add", 'stress', 20000)
		
	elseif work_position.type == 'lunch_break' then
		TaskStartScenarioAtPosition(playerPed, "WORLD_HUMAN_SEAT_WALL_EATING", -447.80, 6013.20, 31.72, work_position.heading, 10000, 0, 1)
		Wait(10000)
		TriggerEvent("esx_status:add", 'hunger', 100000)
	else
		TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_TOURIST_MOBILE", 0, true)
		Wait(digitalizing_work_animation_time)
		TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
		Wait(clipboard_work_animation_time)
	end

	ClearPedTasksImmediately(playerPed)

	delete_object(`p_amb_coffeecup_01`)
	delete_object(`p_cs_clipboard`)
	delete_object(`prop_amb_donut`)
end