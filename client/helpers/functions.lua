
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

	if (difference > 0) then
		return ESX.ShowNotification("You need more " .. difference .. " work point(s) to work here")
	end

	ESX.ShowNotification("You started your shift")
	local job_specific_points = get_player_work_experience('job', job_name)
	local skill_points = get_skill_points_for_job(job_name)
	TriggerServerEvent('toggleJob:paletoLives', job_name, (job_specific_points + skill_points))
end

function get_skill_points_for_job(job_name)
	if job_name == 'electrician' then return get_player_skill_experience('electrical_engineering') end
	if job_name == 'factory_helper' then return get_player_skill_experience('information_technology') end
	if job_name == 'police_intern' then return get_player_skill_experience('law') end
	return 0
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

function get_player_skill_experience(skill)
	local player_skill_experience, retval = {}, 0

	ESX.TriggerServerCallback("getSkillExperience:paletoLives", function(skill_experience)
		player_skill_experience = skill_experience
	end)

	while not player_skill_experience do Wait(100) end

	for i = 1, #player_skill_experience do
		if player_skill_experience[i].skill_name == skill then
			retval = player_skill_experience[i].skill_points
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
