local createdPeds = false
local ov3 = vector3(-300.92, 6256.44, 31.48)
local iv3 = vector3(1121.05, -3152.782, -37.01859)

CreateThread(function()
	if Config.CommuneDisabled then return end
	setupBlip({ title="Paleto Bar", colour=5, id=827 , v3=ov3 })
	while true do
		Citizen.Wait(0)
		DrawMarker(0, ov3.x, ov3.y, ov3.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 244, 244, 23, 100, true, true, 2, true, false, false, false)
		DrawMarker(0, iv3.x, iv3.y, iv3.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 244, 244, 23, 100, true, true, 2, true, false, false, false)

		if coordinates_close_enough(ov3) then
		DisplayHelpText("Press ~INPUT_CONTEXT~ to enter the ~y~bar")
			if(IsControlJustReleased(1, 38)) then
				DoScreenFadeOut(1000)
				Wait(1000)
				SetEntityCoords(PlayerPedId(), 1121.05, -3152.782, -37.01859)
				createBarPeds()
				DisplayRadar(false)
				DoScreenFadeIn(1000)
			end
		end

		if coordinates_close_enough(iv3) then
			DisplayHelpText("Press ~INPUT_CONTEXT~ to exit the ~y~bar")
			if(IsControlJustReleased(1, 38)) then
				DoScreenFadeOut(1000)
				Wait(1000)
				SetEntityCoords(PlayerPedId(),-300.92, 6256.44, 31.48)
				DisplayRadar(true)
				DoScreenFadeIn(1000)
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if coordinates_close_enough(vector3(1122.151, -3146.637, -37.07), 12.0) then
			ShakeGameplayCam('DRUNK_SHAKE', 0.5)
			missionText("Enjoying the bar lowers stress", 1)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1000)
		if coordinates_close_enough(vector3(1122.151, -3146.637, -37.07), 12.0) then
			TriggerEvent("esx_status:remove", 'stress', 400)
		end
	end
end)


function createBarPeds()
	if createdPeds then return end
	createSingleBarPed('scenario', 0xE5A11106, vector3(1121.16, -3143.81, -38.07), "WORLD_HUMAN_STAND_MOBILE_CLUBHOUSE", 269.29)
	createSingleBarPed('scenario', 0x84F9E937, vector3(1123.71, -3142.76, -38.57), "PROP_HUMAN_SEAT_BENCH_DRINK_BEER", 172.91)
	createSingleBarPed('scenario', 0x1383A508, vector3(1124.58, -3142.76, -38.57), "PROP_HUMAN_SEAT_STRIP_WATCH", 184.25)
	createSingleBarPed('scenario', 0x1A021B83, vector3(1125.257, -3146.34, -38.57), "PROP_HUMAN_SEAT_BENCH_DRINK", 76.53)
	createSingleBarPed('scenario', 0x2F4AEC3E, vector3(1121.221, -3146.17, -38.07), "WORLD_HUMAN_SEAT_LEDGE", 187.08)
	createSingleBarPed('scenario', 0xFA389D4F, vector3(1123.331, -3148.37, -38.07), "WORLD_HUMAN_CHEERING", 138.89)
	createSingleBarPed('scenario', 0x8247D331, vector3(1122.817, -3149.26, -38.07), "WORLD_HUMAN_CHEERING", 308.97)
end

function createSingleBarPed(scene_anim, hash, v3, ped_scenario, heading)
	RequestModel(hash)

	while not HasModelLoaded(hash) do
		Wait(1)
	end

	local ped = CreatePed(1, hash,v3.x,v3.y,v3.z, 60, false, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	SetPedDiesWhenInjured(ped, false)
	SetPedCanPlayAmbientAnims(ped, true)
	SetPedCanRagdollFromPlayerImpact(ped, false)
	SetEntityInvincible(ped, true)
	SetEntityHeading(ped, heading)
	FreezeEntityPosition(ped, true)
	
	if scene_anim == 'scenario' then
		TaskStartScenarioInPlace(ped, ped_scenario, 0, true);
	else
		ESX.Streaming.RequestAnimDict(scene_anim, function()
			TaskPlayAnim(PlayerPedId(), scene_anim, ped_scenario, 8.0, -8.0, -1, 0, 0.0, false, false, false)
			RemoveAnimDict(scene_anim)
		end)
	end
	return ped
end

RegisterCommand('createbarpeds',function()
	createBarPeds()
end)