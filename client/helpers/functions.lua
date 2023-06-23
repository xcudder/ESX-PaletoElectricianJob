
function setupBlip(info)
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

function display_work_cta(isWorking, random_work_position)
	local player_position = GetEntityCoords(GetPlayerPed(-1), false)
	local work_player_distance = Vdist(random_work_position.x, random_work_position.y, random_work_position.z, player_position.x, player_position.y, player_position.z)
	return work_player_distance < 1.5 and isWorking == false
end


function start_work(job_name, needed_points)
	if not needed_points then needed_points = 0 end
	local total_player_points = get_player_work_experience('total')
	local difference = needed_points - total_player_points
	if (difference > 0) then return ESX.ShowNotification("You need more " .. difference .. " work point(s) to work here") end
	ESX.ShowNotification("You started your shift")
	local job_specific_points = get_player_work_experience('job', job_name)
	TriggerServerEvent('toggleJob:paletoLives', job_name, job_specific_points)
end

function get_player_work_experience(query, param)
	local player_work_experience, retval = false, 0

	ESX.TriggerServerCallback("getWorkExperience:paletoLives", function(work_experience) player_work_experience = work_experience end)
	while not player_work_experience do Wait(100) end

	if query == 'job' and param then
		for i = 1, #player_work_experience do
			if player_work_experience[i].job_name == param then
				retval = player_work_experience[i].work_points
			end
		end
	elseif query == 'total' then
		for i = 1, #player_work_experience do
			retval = retval +  player_work_experience[i].work_points
		end
	end
	return retval
end

function drawWorkMarker(wp, marker_type)
	if not marker_type then marker_type = 1 end
	DrawMarker(marker_type, wp.x, wp.y, wp.z,0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 155, 0, 0, 2, 0, 0, 0, 0)
end

function create_task_giver(work_cfg, quest_giver_scenario)
	RequestModel(work_cfg.QuestGiver.NPCHash)
	
	while not HasModelLoaded(work_cfg.QuestGiver.NPCHash) do
		Wait(1)
	end

	local quest_giver = CreatePed(1, work_cfg.QuestGiver.NPCHash, work_cfg.QuestGiver.x, work_cfg.QuestGiver.y, work_cfg.QuestGiver.z, 60, false, true)
	SetBlockingOfNonTemporaryEvents(quest_giver, true)
	SetPedDiesWhenInjured(quest_giver, false)
	SetPedCanPlayAmbientAnims(quest_giver, true)
	SetPedCanRagdollFromPlayerImpact(quest_giver, false)
	SetEntityInvincible(quest_giver, true)
	FreezeEntityPosition(quest_giver, true)
	TaskStartScenarioInPlace(quest_giver, quest_giver_scenario, 0, true);
	return quest_giver
end

function run_work_animations(work, work_position, points)
	if work == 'cleaner' then
		run_cleaner_animation(work_position, points)
	elseif work == 'electrician' then
		run_electrician_animation(work_position, points)
	elseif work == 'factory_helper' then
		run_factory_helper_animation(work_position, points)
	elseif work == 'police_intern' then
		run_intern_animation(work_position, points)
	end
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

function run_cleaner_animation(work_position, workPoints) -- right now unused
	local playerPed = PlayerPedId()

	RequestAnimDict("amb@world_human_janitor@male@idle_a")
	Wait(100)
	local broom = CreateObject(GetHashKey("prop_tool_broom2"), 0, 0, 0, true, true, true)
	AttachEntityToEntity(broom, playerPed, GetPedBoneIndex(playerPed, 0x188E), 0.6, 0.7, 0.5, -150.0, 100.0, 220.0, true, true, false, true, 1, true)
	TaskPlayAnim(GetPlayerPed(-1), 'amb@world_human_janitor@male@idle_a', 'idle_a', 12.0, 4.0, 7200, 5, 0.2, false, false, false)
	Wait(7200)
	DetachEntity(broom, 1, true)
	DeleteEntity(broom)
	DeleteObject(broom)
	RemoveAnimDict("amb@world_human_janitor@male@idle_a")
end

function run_electrician_animation(work_position, workPoints) --work position still unused
	setPlayerAtWorkPosition(work_position)

	local each_animation_time = 10000 - workPoints
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

function delete_object(obj_hash)
	v3 = GetEntityCoords(PlayerPedId())
	local obj = GetClosestObjectOfType(v3.x, v3.y, v3.z, 100.0, obj_hash, false, false, false)
	SetEntityAsMissionEntity(obj, true, true)
	DeleteObject(obj)
	SetEntityAsNoLongerNeeded(obj)
end

function entity_close_enough(second_entity, overwrite_radius)
	if not overwrite_radius then overwrite_radius = 1.5 end
	local A = GetEntityCoords(GetPlayerPed(-1), false)
	local B = GetEntityCoords(second_entity, false)
	return Vdist(B.x, B.y, B.z, A.x, A.y, A.z) < 1.5
end

function coordinates_close_enough(B, overwrite_radius)
	if not overwrite_radius then overwrite_radius = 1.5 end
	local A = GetEntityCoords(GetPlayerPed(-1), false)
	return Vdist(B.x, B.y, B.z, A.x, A.y, A.z) < 1.5
end

function generate_new_work_order(job_config, current_work_blip, cb)
	if current_work_blip then RemoveBlip(current_work_blip) end
	local new_work = job_config.WorkPoints[math.random(#job_config.WorkPoints)]
	ClearAreaOfPeds(new_work.x, new_work.y, new_work.z, 1.5)
	cb(new_work, AddBlipForCoord(new_work.x, new_work.y, 30.0))
end

function trigger_job_progression(job, points_worked_on, progression_step, multiplier)
	if  math.fmod(points_worked_on, progression_step) == 0 then
		ESX.ShowNotification("You've worked a total of "..points_worked_on.." points since the start of your shift.")
		reward(job, progression_step, multiplier)
	end
end

function reward(job, progression_step, multiplier) -- to be ran on step progression
	local reward = 1
	if multiplier then reward = reward * multiplier end
	TriggerServerEvent("giveReward:paletoLives", reward, job, progression_step)
end

function stop_work(job)
	TriggerServerEvent('toggleJob:paletoLives', 'unemployed')
	getOutOfUniform()
end

function putUniformOn(clothes_config)
	if not grade then grade = 1 end
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, clothes_config.male)
		elseif skin.sex == 1 then
			TriggerEvent('skinchanger:loadClothes', skin, clothes_config.female)
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

function setPlayerAtWorkPosition(v3)
	SetEntityCoords(PlayerPedId(), v3.x, v3.y, v3.z)
	SetEntityHeading(PlayerPedId(), v3.heading)
end
