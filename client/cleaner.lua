local PlayerData = {}

--counters
local points_worked_on = 0
local reward = 0

-- boilerplating
local quest_giver = false
local local_cfg = Config.paleto_cleaner

-- randow work temp storage
local random_property_blip = false
local random_property = {}
local random_work_position_blip = false
local random_work_position = {}
local isWorking = false

-- propety load stuff
local properties_payload, properties, closeby_properties = false, false, {}

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	if PlayerData.job and PlayerData.job.name == 'cleaner' then
		putUniformOn(local_cfg.Clothes)
		generate_new_outer_work_order(true)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	if PlayerData.job and PlayerData.job.name ~= 'cleaner' then
		RemoveBlip(random_property_blip)
		RemoveBlip(random_work_position_blip)
		clear_out_property_variables()
	else
		putUniformOn(local_cfg.Clothes)
		generate_new_outer_work_order(true)
	end
end)

-- One time setup
Citizen.CreateThread(function()
	quest_giver = create_task_giver(local_cfg, "WORLD_HUMAN_SMOKING")
	setupBlip({
		title="Cleaning Service",
		colour=0, id=837,
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

		if random_property_blip then
			drawWorkMarker(random_property.Entrance, 1)
			if coordinates_close_enough(random_property.Entrance) then
				DisplayHelpText("Press ~INPUT_CONTEXT_SECONDARY~ to enter and clean the house")
				if(IsControlJustReleased(1, 52)) then ESX.ShowNotification("Would be entering now") end
			end
		end

		if entity_close_enough(quest_giver) then
			if PlayerData.job and PlayerData.job.name ~= 'cleaner' then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to start the job")
				if(IsControlJustReleased(1, 38)) then TriggerServerEvent('toggleJob:paletoWorks', 'cleaner') end
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
		if PlayerData.job and PlayerData.job.name == 'cleaner' and random_work_position then
			drawWorkMarker(random_work_position)
			if display_work_cta(isWorking, random_work_position) then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to ~r~working")
				if(IsControlJustReleased(1, 38)) then cleaner_working() end
			end
		end
	end
end)

-- Job specific block of logic
function cleaner_working()
	isWorking = true
	Citizen.CreateThread(function()
		Citizen.Wait(10)
		run_work_animations('cleaner', random_work_position, GetPlayerPed(-1))
		isWorking = false
		generate_new_work_order()
		points_worked_on = points_worked_on + 1
		communicate_job_progression('Cleaner', points_worked_on, 4)
	end)
end

function generate_new_outer_work_order(clear)
	local xyz1, xyz2 = GetEntityCoords(GetPlayerPed(-1), false), false

	if clear or next(closeby_properties) == nil then
		closeby_properties = {}
		ESX.TriggerServerCallback("getProperties:paletoWorks", function(properties_json) properties_payload = properties_json end)
		while not properties_payload do Wait(100) end
		properties = json.decode(properties_payload)

		if(next(properties) == nil) then
			ESX.ShowNotification("No properties to clean nearby")
			stop_work('cleaner', points_worked_on, 4)
		end

		for i = 1, #properties do
			xyz2 = properties[i].Entrance
			if Vdist(xyz1.x, xyz1.y, xyz1.z, xyz2.x, xyz2.y, xyz2.z) < 1000 then
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