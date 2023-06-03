
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

function run_work_animations(work, work_position, playerPed)
	if work == 'cleaner' then
		run_cleaner_animation(work_position, playerPed)
	elseif work == 'electrician' then
		run_electrician_animation(work_position, playerPed)
	elseif work == 'factory_helper' then
		run_factory_helper_animation(work_position, playerPed)
	end
end

function run_cleaner_animation()
	RequestAnimDict("amb@world_human_janitor@male@idle_a")
	Wait(100)
	local broom = CreateObject(GetHashKey("prop_tool_broom2"), 0, 0, 0, true, true, true)
	AttachEntityToEntity(broom, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x188E), 0.6, 0.7, 0.5, -150.0, 100.0, 220.0, true, true, false, true, 1, true)
	TaskPlayAnim(GetPlayerPed(-1), 'amb@world_human_janitor@male@idle_a', 'idle_a', 12.0, 4.0, 7200, 5, 0.2, false, false, false)
	Wait(7200)
	DetachEntity(broom, 1, true)
	DeleteEntity(broom)
	DeleteObject(broom)
end

function run_electrician_animation(work_position, playerPed)
	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
	Wait(10000)
	TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_POLICE_INVESTIGATE", 0, true)
	Wait(10000)
	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
	Wait(10000)
	ClearPedTasksImmediately(playerPed)
end

function run_factory_helper_animation(work_position, playerPed)
	if work_position.type == 'computer' then
		RequestAnimDict("abigail_mcs_1_concat-9")
		Citizen.Wait(100)
		TaskPlayAnim(playerPed, 'abigail_mcs_1_concat-9', 'csb_abigail_dual-9', 12.0, 12.0, -1, 81, 0.0, 1, 1, 1)
		SetEntityHeading(playerPed, 375.0)
		Wait(10000)
		StopAnimTask(playerPed, 'abigail_mcs_1_concat-9', 'csb_abigail_dual-9')
	else
		TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
		Wait(15000)
		ClearPedTasksImmediately(playerPed)
	end
end

function entity_close_enough(second_entity)
	local A = GetEntityCoords(GetPlayerPed(-1), false)
	local B = GetEntityCoords(second_entity, false)
	return Vdist(B.x, B.y, B.z, A.x, A.y, A.z) < 1.5
end

function coordinates_close_enough(B)
	local A = GetEntityCoords(GetPlayerPed(-1), false)
	return Vdist(B.x, B.y, B.z, A.x, A.y, A.z) < 1.5
end

function generate_new_work_order(job_config, current_work_blip, cb)
	if current_work_blip then RemoveBlip(current_work_blip) end
	local new_work = job_config.WorkPoints[math.random(#job_config.WorkPoints)]
	cb(new_work, AddBlipForCoord(new_work.x, new_work.y, 30.0))
end

function communicate_job_progression(job, points_worked_on, progression_step)
	if  math.fmod(points_worked_on, progression_step) == 0 then
		TriggerEvent('notifications', "#29c501", job, "You've worked a total of "..points_worked_on.." points")
	end
end

function stop_work(job, points_worked_on, progression_step, multiplier)
	TriggerServerEvent('toggleJob:paletoWorks', 'unemployed')
	getOutOfUniform()
	reward = math.floor(points_worked_on / progression_step)
	if multiplier then reward = reward * multiplier end
	TriggerEvent('notifications', "#29c501", job, "You've become ".. reward .."$ richer")
	TriggerServerEvent("giveReward:paletoWorks", reward)
end

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