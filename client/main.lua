
ESX                             =  exports["es_extended"]:getSharedObject()
local PlayerData                = {}
local HasAlreadyEnteredMarker   = false
local onDuty                    = false
local BlipCloakRoom             = nil
local BlipVehicle               = nil
local BlipVehicleDeleter		= nil
local Blips                     = {}
local OnJob                     = false
local Done 						= false
local isinwork 					= false  



RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	onDuty = false
	CreateBlip()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	onDuty = false
	CreateBlip()
end)

-- NPC MISSIONS
function SelectGarden()
	local index = GetRandomIntInRange(1,  #Config.Garden)

	for k,v in pairs(Config.Zones) do
		if v.Pos.x == Config.Garden[index].x and v.Pos.y == Config.Garden[index].y and v.Pos.z == Config.Garden[index].z then
			print(k)
			return k
			
		end
	end
end

function StartNPCJob()

	NPCTargetGarden     = SelectGarden()
	local zone            = Config.Zones[NPCTargetGarden]
	Blips['NPCTargetGarden'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
	SetBlipRoute(Blips['NPCTargetGarden'], true)
	lib.notify({
		title = 'Garden',
		description = _U('GPS_info'),
		type = 'error',
		icon = 'person-digging',
		position = 'top'
	})
	Done = true
	Onjob = true

end

function StopNPCJob(cancel)
	if Blips['NPCTargetGarden'] ~= nil then
		RemoveBlip(Blips['NPCTargetGarden'])
		Blips['NPCTargetGarden'] = nil
	end

	OnJob = false

	if cancel then
		lib.notify({
			title = 'Garden',
			description = _U('cancel_mission'),
			type = 'error',
			icon = 'person-digging',
			position = 'top'
		})
	else
		TriggerServerEvent('d_cleanergive:givereceipt')
		StartNPCJob()
		Done = true
	end


end



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if NPCTargetGarden ~= nil then
			local v2 = GetEntityCoords(PlayerPedId())
			local zone = Config.Zones[NPCTargetGarden]
			local zonec = vector3(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
			local playerPed = GetPlayerPed(-1)
			local dist = #(zonec - v2)
			if dist < Config.DrawDistance then
				DrawMarker(Config.Garden.Type, zone.Pos.x, zone.Pos.y, zone.Pos.z , 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, Config.Garden.Size,Config.Garden.Size, Config.Garden.Size, Config.Garden.R, Config.Garden.G, Config.Garden.B, 50, false, true, 2, nil, nil, false)
				if dist < 2 then
					lib.showTextUI('[E] - '.. _U('clean'))
					if IsControlJustReleased(1, Config.KeyClean)  then
						lib.progressCircle({
							duration = Config.Cleantime,
							position = 'bottom',
							useWhileDead = false,
							canCancel = false,
							disable = {
								car = true,
								move = true,
							},
							anim = {
								dict = 'anim@amb@drug_field_workers@rake@male_a@base',
								clip = 'base'
							},
							prop = {
								model = `prop_tool_shovel006`,
								pos = vec3(-0.2, 0.2, 0.02),
								rot = vec3(0.0, 0.0, -1.5)
							},
							bone = 60309
						})
						StopNPCJob() 
						Done = false
					end
				end	

			end
		end
	end
end)


-- UNIFORMY


RegisterNetEvent('d_setuniform')
	AddEventHandler('d_setuniform', function()
		if isinwork == false then
		lib.progressCircle({
			duration = 4500,
			position = 'bottom',
			useWhileDead = false,
			canCancel = false,
			disable = {
				car = true,
			},
			anim = {
				dict = 'missmic4',
				clip = 'michael_tux_fidget'
			},
		})
		lib.notify({
			title = 'Garden',
			description = _U('take_service_notif'),
			type = 'success',
			icon = 'person-digging',
			position = 'top'
		})
		setUniform('job_wear', playerPed)
		onDuty = true
		isinwork = true
	elseif isinwork == true then
		lib.notify({
			title = 'Garden',
			description = _U('already_w'),
			type = 'error',
			position = 'top',
			icon = 'x'
		})

	end
	end)

	RegisterNetEvent('d_setciv')
	AddEventHandler('d_setciv', function()
		if isinwork == true then
		lib.progressCircle({
			duration = 4500,
			position = 'bottom',
			useWhileDead = false,
			canCancel = false,
			disable = {
				car = true,
			},
			anim = {
				dict = 'missmic4',
				clip = 'michael_tux_fidget'
			},
		})
		lib.notify({
			title = 'Garden',
			description = _U('end_service_notif'),
			type = 'error',
			icon = 'person-digging',
			position = 'top'
		})
		isinwork = false
		onDuty = false
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			local model = nil

			if skin.sex == 0 then
			  model = GetHashKey("mp_m_freemode_01")
			else
			  model = GetHashKey("mp_f_freemode_01")
			end

			RequestModel(model)
			while not HasModelLoaded(model) do
			  RequestModel(model)
			  Citizen.Wait(1)
			end

			SetPlayerModel(PlayerId(), model)
			SetModelAsNoLongerNeeded(model)

			TriggerEvent('skinchanger:loadSkin', skin)
			TriggerEvent('esx:restoreLoadout')

			local playerPed = GetPlayerPed(-1)
			-- SetPedArmour(playerPed, 0)
			ClearPedBloodDamage(playerPed)
			ResetPedVisibleDamage(playerPed)
			ClearPedLastWeaponDamage(playerPed)
		end)	
	elseif isinwork == false then
		lib.notify({
			title = 'Garden',
			description = _U('already_w'),
			type = 'error',
			icon = 'x',
			position = 'top'
		})
	end
	end)

	RegisterNetEvent('d_spawnvehicle')
	AddEventHandler('d_spawnvehicle', function()
		local playerPed = GetPlayerPed(-1)
		local coords    = Config.Zones.VehicleSpawnPoint.Pos
		local Heading    = Config.Zones.VehicleSpawnPoint.Heading
		ESX.Game.SpawnVehicle('bison', coords, Heading, function(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		end)

	end)


	lib.registerContext({
		id = 'd_cleaner_d',
		title = 'Cloakroom',
		options = {
			{
				title = 'Work Uniform',
				icon = 'fa-vest-patches',
				arrow = false,
				event = 'd_setuniform'
			},
			{
				title = 'Civilian Uniform',
				icon = 'fa-shirt',
				arrow = false,
				event = 'd_setciv'
	
			},
			{
				title = 'Help',
				icon = 'fa-question',
				arrow = false,
				onSelect = function()

					local alert =	lib.alertDialog({
						   header = 'Help',
						   content = _U('help_t'),
						   centered = true,
						   cancel = true
					   })
					   print(alert)
				   end
				   
	
			}
		}
	})

	lib.registerContext({
		id = 'd_cleaner_v',
		title = 'Garages',
		options = {
			{
				title = 'Work Car',
				icon = 'fa-car',
				arrow = false,
				event = 'd_spawnvehicle'
			},
		}
	})

-- Start work / finish work
function CloakRoomMenu()

	lib.showContext('d_cleaner_d')

end


-- Spawn your work vehicle
function VehicleMenu()
	lib.showContext('d_cleaner_v')
end

function ReceiptSell()
	local input = lib.inputDialog(_U('InputName'), {_U('InputPlaceholder')})
	if not input then return end
	local lockerNumber = tonumber(input[1])
	TriggerServerEvent("d_sellreceipts", lockerNumber)
end


function CreateBlip()
	if PlayerData.job ~= nil and PlayerData.job.name == Config.nameJob then
		if BlipCloakRoom == nil then
			BlipCloakRoom = AddBlipForCoord(-1139.43, -200.15,  37.96)
			SetBlipSprite(BlipCloakRoom, 623)
			SetBlipColour(BlipCloakRoom, 24)
			SetBlipAsShortRange(BlipCloakRoom, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blipname'))
			SetBlipScale(BlipCloakRoom, 0.8)
			EndTextCommandSetBlipName(BlipCloakRoom)
		end
	end
end

-- Activation of the marker on the ground
Citizen.CreateThread(function()
	while true do
		Wait(1)
		if PlayerData.job ~= nil and  PlayerData.job.name == Config.nameJob then
			local v1 = Config.Zones.Cloakroom.Pos
			local v3 = Config.Zones.VehicleSpawn.Pos
			local v4 = Config.Zones.VehicleDeleter.Pos
			local v5 = Config.Zones.ReceiptSell.Pos
			local playercoords = GetEntityCoords(PlayerPedId())
			local dist = #(v1 - playercoords)
			local dist2 = #(v3 - playercoords)
			local dist4 = #(v4 - playercoords)
			local dist5 = #(v5 - playercoords)
			local isInMarker  = false
			local currentZone = nil
			local DeleterShown = false
			local vehicle   = GetVehiclePedIsIn(PlayerPedId(),  false)

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('pex_garden:hasEnteredMarker', currentZone)
			end
			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('pex_garden:hasExitedMarker', LastZone)
			end	

			local danny = true

			if danny == true then
					if dist < Config.DrawDistance  then
						DrawMarker(Config.Zones.Cloakroom.Type, Config.Zones.Cloakroom.Pos.x, Config.Zones.Cloakroom.Pos.y, Config.Zones.Cloakroom.Pos.z + 2, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, Config.Zones.Cloakroom.Size, Config.Zones.Cloakroom.Size,Config.Zones.Cloakroom.Size, Config.Zones.Cloakroom.R, Config.Zones.Cloakroom.G, Config.Zones.Cloakroom.B, 100, false, true, 2, nil, nil, false)
					end
					if dist2 < Config.DrawDistance and onDuty == true then
						DrawMarker(Config.Zones.VehicleSpawn.Type, Config.Zones.VehicleSpawn.Pos.x, Config.Zones.VehicleSpawn.Pos.y, Config.Zones.VehicleSpawn.Pos.z, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.Zones.VehicleSpawn.Size, Config.Zones.VehicleSpawn.Size, Config.Zones.VehicleSpawn.Size, Config.Zones.VehicleSpawn.R, Config.Zones.VehicleSpawn.G, Config.Zones.VehicleSpawn.B, 100, false, true, 2, nil, nil, false)
							
					end
					if dist4 < Config.DrawDistance and IsPedInAnyVehicle(PlayerPedId(), false) then
						DrawMarker(Config.Zones.VehicleDeleter.Type, Config.Zones.VehicleDeleter.Pos.x, Config.Zones.VehicleDeleter.Pos.y, Config.Zones.VehicleDeleter.Pos.z, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.Zones.VehicleDeleter.Size, Config.Zones.VehicleDeleter.Size, Config.Zones.VehicleDeleter.Size, Config.Zones.VehicleDeleter.R, Config.Zones.VehicleDeleter.G, Config.Zones.VehicleDeleter.B, 100, false, true, 2, nil, nil, false)
						DeleterShown = true
					end
					if dist5 < Config.DrawDistance  then
						DrawMarker(Config.Zones.ReceiptSell.Type, Config.Zones.ReceiptSell.Pos.x, Config.Zones.ReceiptSell.Pos.y, Config.Zones.ReceiptSell.Pos.z, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.Zones.ReceiptSell.Size, Config.Zones.ReceiptSell.Size, Config.Zones.ReceiptSell.Size, Config.Zones.ReceiptSell.R, Config.Zones.ReceiptSell.G, Config.Zones.ReceiptSell.B, 100, false, true, 2, nil, nil, false)

					end
					if dist < 2 then
						isInMarker  = true
						lib.showTextUI('[E] - '.._U('cloakroom'))
						if IsControlJustReleased(1, Config.Key) then
							CloakRoomMenu()
						end
					elseif dist2 < 2 and onDuty == true then
						lib.showTextUI('[E] - '.._U('garage'))
						if IsControlJustReleased(1, Config.Key) then
							VehicleMenu()
						end
					elseif dist4 < 2 and DeleterShown == true then
						lib.showTextUI('[E] - '.._U('deleter'))
						if IsControlJustReleased(1, Config.Key) then
							DeleteVehicle(vehicle)
						end
					elseif dist5 < 2 then
						lib.showTextUI('[E] - '.._U('seller'))
						if IsControlJustReleased(1, Config.Key) then
							ReceiptSell()
						end
					end
			
			end
		end



	end
end)


	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(7)
			--and onDuty == true
			if IsControlJustReleased(1, Config.KeyJobStart) and PlayerData.job.name == Config.nameJob then
				if Onjob then
				StopNPCJob(true)
				RemoveBlip(Blips['NPCTargetGarden'])
				Onjob = false
			else
				local playerPed = GetPlayerPed(-1)
				if IsPedInAnyVehicle(playerPed,  false) and IsVehicleModel(GetVehiclePedIsIn(playerPed,  false), GetHashKey(Config.Vehicles.Hash)) then
				StartNPCJob()
				Onjob = true
			else
				lib.notify({
					title = 'Garden',
					description =_U('wrongcar'),
					type = 'error',
					icon = 'person-digging',
					position = 'top'
				})
			end
		end
			end
		end
	end)

	function setUniform(job, playerPed)
		TriggerEvent('skinchanger:getSkin', function(skin)
	  
		  if skin.sex == 0 then
			if Config.WorkUniform[job].male ~= nil then
			  TriggerEvent('skinchanger:loadClothes', skin, Config.WorkUniform[job].male)
			else
			  ESX.ShowNotification(_U('no_outfit'))
			end
		  else
			if Config.WorkUniform[job].female ~= nil then
			  TriggerEvent('skinchanger:loadClothes', skin, Config.WorkUniform[job].female)
			else
			  ESX.ShowNotification(_U('no_outfit'))
			end
		  end
	  
		end)
	  end
	  