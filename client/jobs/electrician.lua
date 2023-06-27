local PlayerData = {}

--counters
local points_worked_on = 0

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
		PlayerData.electrician_points = get_player_work_experience('job', PlayerData.job.name)
		PlayerData.electrician_points = PlayerData.electrician_points + get_player_skill_experience('electrical_engineering')

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

	if PlayerData.job and PlayerData.job.name ~= 'electrician' then
		points_worked_on = 0
		if DoesBlipExist(random_work_position_blip) then
			RemoveBlip(random_work_position_blip)
		end
	else
		PlayerData.electrician_points = get_player_work_experience('job', PlayerData.job.name)
		PlayerData.electrician_points = PlayerData.electrician_points + get_player_skill_experience('electrical_engineering')

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
		title="Power Plant #1",
		colour=0, id=620,
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
			if PlayerData.job and PlayerData.job.name ~= 'electrician' then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to start the job")
				if(IsControlJustReleased(1, 38))then start_work('electrician', 150) end
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
	local multiplier = 1
	if PlayerData.electrician_points >= 4000 then multiplier = 4 end
	if PlayerData.electrician_points >= 10000 then multiplier = 8 end
	Citizen.CreateThread(function()
		Citizen.Wait(10)
		run_electrician_animation(random_work_position, PlayerData.electrician_points)
		isWorking = false
		generate_new_work_order(local_cfg, random_work_position_blip, function(new_work, new_blip)
			random_work_position = new_work
			random_work_position_blip = new_blip
		end)
		points_worked_on = points_worked_on + 1
		trigger_job_progression('electrician', points_worked_on, 4, multiplier)
	end)
end

function run_electrician_animation(work_position, workPoints) --work position still unused
	setPlayerAtWorkPosition(work_position)

	local each_animation_time = 10000 - workPoints
	if each_animation_time < 1000 then each_animation_time = 1000 end

	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
	Wait(each_animation_time)
	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WINDOW_SHOP_BROWSE", 0, true)
	delete_object(`p_cs_clipboard`)
	Wait(each_animation_time)
	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
	Wait(each_animation_time)
	ClearPedTasksImmediately(playerPed)
	delete_object(`prop_weld_torch`)
end