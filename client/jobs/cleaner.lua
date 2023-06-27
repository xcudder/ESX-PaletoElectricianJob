local PlayerData = {}

--counters
local points_worked_on = 0

-- boilerplating
local quest_giver = false
local local_cfg = Config.paleto_cleaner

-- randow work temp storage
local random_property_blip = false
local random_property = {}
local isInside = false
local isWorking = false
local workSpots = {}
local houseWorkedPoints = 0
local totalWorkPointsInThisHouse = 0

-- propety load stuff
local properties_payload, properties, closeby_properties = false, false, {}

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	local grade = 0
	PlayerData = xPlayer
	-- below is if something went wrong... go to the quest giver
	if isInside then TriggerServerEvent("enterProperty:paletoLives", false, local_cfg.QuestGiver) end

	if PlayerData.job and PlayerData.job.name == 'cleaner' then
		putUniformOn(local_cfg.Clothes[grade + 1])
		generate_new_outer_work_order(true)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	local grade = 0
	PlayerData.job = job

	-- below is if something went wrong... go to the quest giver
	if isInside then TriggerServerEvent("enterProperty:paletoLives", false, local_cfg.QuestGiver) end

	if PlayerData.job and PlayerData.job.name ~= 'cleaner' then
		points_worked_on = 0
		if DoesBlipExist(random_property_blip) then
			RemoveBlip(random_property_blip)
		end
		clear_out_property_variables()
	else
		putUniformOn(local_cfg.Clothes[grade + 1])
		generate_new_outer_work_order(true)
	end
end)

-- One time setup
Citizen.CreateThread(function()
	quest_giver = create_task_giver(local_cfg, "WORLD_HUMAN_JANITOR")
	setupBlip({
		title="Cleaning Service",
		colour=0, id=837,
		x=local_cfg.QuestGiver.x,
		y=local_cfg.QuestGiver.y,
		z=local_cfg.QuestGiver.z
	})
end)

-- Continuous check of quest-giver-proximity based logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		while not quest_giver do Wait(1) end

		if random_property_blip then
			drawWorkMarker(random_property.Entrance, 1)
			if coordinates_close_enough(random_property.Entrance) then
				DisplayHelpText("Press ~INPUT_CONTEXT_SECONDARY~ to enter and clean the house")
				if(IsControlJustReleased(1, 52)) then enter_house() end
			end
		end

		if entity_close_enough(quest_giver) then
			if PlayerData.job and PlayerData.job.name ~= 'cleaner' then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to start the job")
				if(IsControlJustReleased(1, 38)) then start_work('cleaner', 850) end
			else
				DisplayHelpText("Press ~INPUT_CONTEXT~ to stop the job")
				if(IsControlJustReleased(1, 38)) then stop_work('cleaner', points_worked_on, 4) end
			end
		end
	end
end)

-- continuous check of random work position logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if PlayerData.job and PlayerData.job.name == 'cleaner' and isInside then
			for i = 1, #workSpots do
				if workSpots[i].active == 1 then
					drawWorkMarker(workSpots[i])
					if display_work_cta(isWorking, workSpots[i]) then
						DisplayHelpText("Press ~INPUT_CONTEXT~ to ~r~working")
						if(IsControlJustReleased(1, 38)) then cleaner_working(i) end
					end
				end
			end
		end
	end
end)

-- Job specific block of logic
function cleaner_working(work_index)
	isWorking = true
	Citizen.CreateThread(function()
		Citizen.Wait(10)
		isWorking = true
		run_cleaner_animation(workSpots[work_index])
		isWorking , workSpots[work_index].active = false, 0
		houseWorkedPoints = houseWorkedPoints + 1
		points_worked_on = points_worked_on + 1
		trigger_job_progression('cleaner', points_worked_on, 5, 2)
		if totalWorkPointsInThisHouse == houseWorkedPoints then -- we're done, get out
			TriggerServerEvent("enterProperty:paletoLives", false, random_property.Entrance)
			isInside = false
			generate_new_outer_work_order()
		end
	end)
end

function run_cleaner_animation(work_position)
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

function generate_new_outer_work_order(clear)
	local xyz1, xyz2 = GetEntityCoords(GetPlayerPed(-1), false), false
	local proper_ipl = false

	if clear or next(closeby_properties) == nil then
		closeby_properties = {}
		ESX.TriggerServerCallback("getProperties:paletoLives", function(properties_json) properties_payload = properties_json end)
		while not properties_payload do Wait(100) end
		properties = json.decode(properties_payload)

		if(next(properties) == nil) then
			ESX.ShowNotification("No properties to clean nearby")
			stop_work('cleaner', points_worked_on, 1)
		end

		for i = 1, #properties do
			xyz2 = properties[i].Entrance
			proper_ipl = (properties[i].Interior == 'low-end' or properties[i].Interior == 'mid-end')
			if Vdist(xyz1.x, xyz1.y, xyz1.z, xyz2.x, xyz2.y, xyz2.z) < 1000 and proper_ipl then
				table.insert(closeby_properties, properties[i])
			end
		end
	end

	random_property = closeby_properties[math.random(#closeby_properties)]
	random_property_blip = AddBlipForCoord(random_property.Entrance.x, random_property.Entrance.y, 30.0)
end

function clear_out_property_variables()
	properties_payload, properties, closeby_properties = false, false, {}
end

function enter_house()
	isInside = random_property.Interior;
	totalWorkPointsInThisHouse, houseWorkedPoints = 0, 0
	workSpots = local_cfg.WorkPoints[random_property.Interior]
	for i = 1, #workSpots do
		workSpots[i].active = 1
		totalWorkPointsInThisHouse = totalWorkPointsInThisHouse + 1
	end
	TriggerServerEvent("enterProperty:paletoLives", random_property.Interior)
	if random_property_blip then RemoveBlip(random_property_blip) end
end