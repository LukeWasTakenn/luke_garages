local garages = {}
local impounds = {}

local currentGarage = nil
local currentImpound = nil
local jobBlips = {}

local ped = nil


local function GetGarageLabel(name)
    for _, garage in pairs(Config.Garages) do
        if garage.zone.name == name then return garage.label end
    end
end

local function SetVehProperties(vehicle, props, health)
    if DoesEntityExist(vehicle) then
        local ent = Entity(vehicle)
        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        SetVehicleDoorsLocked(vehicle, 2)
        SetVehicleModKit(vehicle, 0)
        SetVehicleAutoRepairDisabled(vehicle, true)

        if props.plate then
            SetVehicleNumberPlateText(vehicle, props.plate)
        end

        if props.plateIndex then
            SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
        end

        if props.tankHealth  then
            SetVehiclePetrolTankHealth(vehicle, 1000.0)
        end

        if props.dirtLevel then
            SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
        end

        if props.customPrimaryColor then 
            SetVehicleCustomPrimaryColour(vehicle, props.customPrimaryColor[1], props.customPrimaryColor[2], props.customPrimaryColor[3]) 
        end 

        if props.customSecondaryColor then 
            SetVehicleCustomSecondaryColour(vehicle, props.customSecondaryColor[1], props.customSecondaryColor[2], props.customSecondaryColor[3]) 
        end
        
        if props.color1 then 
            SetVehicleColours(vehicle, props.color1, colorSecondary) 
        end

        if props.color2 then 
            SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) 
        end

        if props.pearlescentColor then 
            SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) 
        end

        if props.interiorColor then
            SetVehicleInteriorColor(vehicle, props.interiorColor)
        end

        if props.dashboardColor then
            SetVehicleDashboardColour(vehicle, props.dashboardColor)
        end

        if props.wheelColor then
            SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor)
        end

        if props.wheels then
            SetVehicleWheelType(vehicle, props.wheels)
        end

        if props.windowTint then
            SetVehicleWindowTint(vehicle, props.windowTint)
        end

        if props.neonEnabled then
            SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
            SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
            SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
            SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
        end

        if props.extras then
            for k, v in pairs(props.extras) do
                SetVehicleExtra(vehicle, k, props.extras[k])
            end
        end

        if props.neonColor then
            SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
        end

        if props.xenonColor then 
            SetVehicleXenonLightsColour(vehicle, props.xenonColor) 
        end

        if props.modSmokeEnabled then
            ToggleVehicleMod(vehicle, 20, true)
        end

        if props.tyreSmokeColor then
            SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
        end

        if props.modSpoilers then
            SetVehicleMod(vehicle, 0, props.modSpoilers, false)
        end

        if props.modFrontBumper then
            SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
        end

        if props.modRearBumper then
            SetVehicleMod(vehicle, 2, props.modRearBumper, false)
        end

        if props.modSideSkirt then
            SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
        end

        if props.modExhaust then
            SetVehicleMod(vehicle, 4, props.modExhaust, false)
        end

        if props.modFrame then
            SetVehicleMod(vehicle, 5, props.modFrame, false)
        end

        if props.modGrille then
            SetVehicleMod(vehicle, 6, props.modGrille, false)
        end

        if props.modHood then
            SetVehicleMod(vehicle, 7, props.modHood, false)
        end

        if props.modFender then
            SetVehicleMod(vehicle, 8, props.modFender, false)
        end

        if props.modRightFender then
            SetVehicleMod(vehicle, 9, props.modRightFender, false)
        end

        if props.modRoof then
            SetVehicleMod(vehicle, 10, props.modRoof, false)
        end

        if props.modEngine then
            SetVehicleMod(vehicle, 11, props.modEngine, false)
        end

        if props.modBrakes then
            SetVehicleMod(vehicle, 12, props.modBrakes, false)
        end

        if props.modTransmission then
            SetVehicleMod(vehicle, 13, props.modTransmission, false)
        end

        if props.modHorns then
            SetVehicleMod(vehicle, 14, props.modHorns, false)
        end

        if props.modSuspension then
            SetVehicleMod(vehicle, 15, props.modSuspension, false)
        end

        if props.modArmor then
            SetVehicleMod(vehicle, 16, props.modArmor, false)
        end

        if props.modTurbo then
            ToggleVehicleMod(vehicle, 18, props.modTurbo)
        end

        if props.modSubwoofer then
            ToggleVehicleMod(vehicle, 19, props.modSubwoofer)
        end

        if props.modHydraulics then
            ToggleVehicleMod(vehicle, 21, props.modHydraulics)
        end

        if props.modXenon then
            ToggleVehicleMod(vehicle, 22, props.modXenon)
        end

        if props.xenonColor then
            SetVehicleXenonLightsColor(vehicle, props.xenonColor)
        end

        if props.modFrontWheels then
            SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomTiresF)
        end

        if props.modBackWheels then
            SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomTiresR)
        end

        if props.modPlateHolder then
            SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
        end

        if props.modVanityPlate then
            SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
        end

        if props.modTrimA then
            SetVehicleMod(vehicle, 27, props.modTrimA, false)
        end

        if props.modOrnaments then
            SetVehicleMod(vehicle, 28, props.modOrnaments, false)
        end

        if props.modDashboard then
            SetVehicleMod(vehicle, 29, props.modDashboard, false)
        end

        if props.modDial then
            SetVehicleMod(vehicle, 30, props.modDial, false)
        end

        if props.modDoorSpeaker then
            SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
        end

        if props.modSeats then
            SetVehicleMod(vehicle, 32, props.modSeats, false)
        end

        if props.modSteeringWheel then
            SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
        end

        if props.modShifterLeavers then
            SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
        end

        if props.modAPlate then
            SetVehicleMod(vehicle, 35, props.modAPlate, false)
        end

        if props.modSpeakers then
            SetVehicleMod(vehicle, 36, props.modSpeakers, false)
        end

        if props.modTrunk then
            SetVehicleMod(vehicle, 37, props.modTrunk, false)
        end

        if props.modHydrolic then
            SetVehicleMod(vehicle, 38, props.modHydrolic, false)
        end

        if props.modEngineBlock then
            SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
        end

        if props.modAirFilter then
            SetVehicleMod(vehicle, 40, props.modAirFilter, false)
        end

        if props.modStruts then
            SetVehicleMod(vehicle, 41, props.modStruts, false)
        end

        if props.modArchCover then
            SetVehicleMod(vehicle, 42, props.modArchCover, false)
        end

        if props.modAerials then
            SetVehicleMod(vehicle, 43, props.modAerials, false)
        end

        if props.modTrimB then
            SetVehicleMod(vehicle, 44, props.modTrimB, false)
        end

        if props.modTank then
            SetVehicleMod(vehicle, 45, props.modTank, false)
        end

        if props.modWindows then
            SetVehicleMod(vehicle, 46, props.modWindows, false)
        end

        if props.modDoorR then
            SetVehicleMod(vehicle, 47, props.modDoorR, false)
        end

        if props.modLivery then
            SetVehicleMod(vehicle, 48, props.modLivery, false)
            SetVehicleLivery(vehicle, props.modLivery)
        end

        if props.modLightbar then
            SetVehicleMod(vehicle, 49, props.modLightbar, false)
        end
        if health ~= nil then
            health.engine = ESX.Math.Round(health.engine, 2)
            health.body = ESX.Math.Round(health.body, 2)

            -- Making the vehicle still drivable if it's completely totaled
            if health.engine < 200.0 then
                health.engine = 200.0
            end
        
            if health.body < 150.0 then
                health.body = 150.0
            end
        
            for _, window in pairs(health.parts.windows) do
                SmashVehicleWindow(vehicle, window)
            end

            for _, tyre in pairs(health.parts.tires) do
                SetVehicleTyreBurst(vehicle, tyre, true, 1000.0)
            end

            for _, door in pairs(health.parts.doors) do
                SetVehicleDoorBroken(vehicle, door, false)
            end

            SetVehicleBodyHealth(vehicle, health.body)
            SetVehicleEngineHealth(vehicle, health.engine)
            if health.fuel ~= nil then
                health.fuel = ESX.Math.Round(health.fuel, 2)
                SetVehicleFuelLevel(vehicle, health.fuel)
                ent.state:set('fuel', health.fuel, true)
            end
        else
            return
        end
        TriggerServerEvent('luke_garages:ChangeStored', props.plate, false, nil)
    end
end

local function getVehProperties(vehicle)
	if DoesEntityExist(vehicle) then
        local ent = Entity(vehicle)
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        local customPrimaryColor, customSecondaryColor = nil

		if GetIsVehiclePrimaryColourCustom(vehicle) then
            local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
			customPrimaryColor = { r, g, b }
		end

		if GetIsVehicleSecondaryColourCustom(vehicle) then
            local r, g, b = GetVehicleCustomSecondaryColour(vehicle)
			customSecondaryColor = { r, g, b }
		end

		local extras = {}

		for i = 0, 14 do
			if DoesExtraExist(vehicle, i) then
				-- [0=on, 1=off]
                if IsVehicleExtraTurnedOn(vehicle, i) then
                    extras[i] = false
                else
                    extras[i] = true
                end
			end
		end

		if GetVehicleMod(vehicle, 48) == -1 and GetVehicleLivery(vehicle) ~= -1 then
			modLivery = GetVehicleLivery(vehicle)
		else
			modLivery = GetVehicleMod(vehicle, 48)
		end

		local neons = {}
		local neonCount = 0

		for i = 0, 3 do
			if IsVehicleNeonLightEnabled(vehicle, i) then
				neonCount += 1
				neons[neonCount] = i
			end
		end

		return {
			model = GetEntityModel(vehicle),
			plate = GetVehicleNumberPlateText(vehicle),
			plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
			bodyHealth = math.floor(GetVehicleBodyHealth(vehicle) + 0.5),
			engineHealth = math.floor(GetVehicleEngineHealth(vehicle) + 0.5),
			tankHealth = math.floor(GetVehiclePetrolTankHealth(vehicle) + 0.5),
			fuelLevel = math.floor(GetVehicleFuelLevel(vehicle) + 0.5),
			dirtLevel = math.floor(GetVehicleDirtLevel(vehicle) + 0.5),
			color1 = colorPrimary,
			color2 = colorSecondary,
            customPrimaryColor = customPrimaryColor,
			customSecondaryColor = customSecondaryColor,
			pearlescentColor = pearlescentColor,
			interiorColor = GetVehicleInteriorColor(vehicle),
			dashboardColor = GetVehicleDashboardColour(vehicle),
			wheelColor = wheelColor,
			wheels = GetVehicleWheelType(vehicle),
			windowTint = GetVehicleWindowTint(vehicle),
			xenonColor = GetVehicleXenonLightsColour(vehicle),
			neonEnabled = neons,
			neonColor = {GetVehicleNeonLightsColour(vehicle)},
			extras = extras,
			tyreSmokeColor = {GetVehicleTyreSmokeColor(vehicle)},
			modSpoilers = GetVehicleMod(vehicle, 0),
			modFrontBumper = GetVehicleMod(vehicle, 1),
			modRearBumper = GetVehicleMod(vehicle, 2),
			modSideSkirt = GetVehicleMod(vehicle, 3),
			modExhaust = GetVehicleMod(vehicle, 4),
			modFrame = GetVehicleMod(vehicle, 5),
			modGrille = GetVehicleMod(vehicle, 6),
			modHood = GetVehicleMod(vehicle, 7),
			modFender = GetVehicleMod(vehicle, 8),
			modRightFender = GetVehicleMod(vehicle, 9),
			modRoof = GetVehicleMod(vehicle, 10),
			modEngine = GetVehicleMod(vehicle, 11),
			modBrakes = GetVehicleMod(vehicle, 12),
			modTransmission = GetVehicleMod(vehicle, 13),
			modHorns = GetVehicleMod(vehicle, 14),
			modSuspension = GetVehicleMod(vehicle, 15),
			modArmor = GetVehicleMod(vehicle, 16),
			modNitrous = GetVehicleMod(vehicle, 17),
			modTurbo = IsToggleModOn(vehicle, 18),
			modSubwoofer = GetVehicleMod(vehicle, 19),
			modSmokeEnabled = IsToggleModOn(vehicle, 20),
			modHydraulics = IsToggleModOn(vehicle, 21),
			modXenon = IsToggleModOn(vehicle, 22),
			modFrontWheels = GetVehicleMod(vehicle, 23),
			modBackWheels = GetVehicleMod(vehicle, 24),
			modCustomTiresF = GetVehicleModVariation(vehicle, 23),
			modCustomTiresR = GetVehicleModVariation(vehicle, 24),
			modPlateHolder = GetVehicleMod(vehicle, 25),
			modVanityPlate = GetVehicleMod(vehicle, 26),
			modTrimA = GetVehicleMod(vehicle, 27),
			modOrnaments = GetVehicleMod(vehicle, 28),
			modDashboard = GetVehicleMod(vehicle, 29),
			modDial = GetVehicleMod(vehicle, 30),
			modDoorSpeaker = GetVehicleMod(vehicle, 31),
			modSeats = GetVehicleMod(vehicle, 32),
			modSteeringWheel = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate = GetVehicleMod(vehicle, 35),
			modSpeakers = GetVehicleMod(vehicle, 36),
			modTrunk = GetVehicleMod(vehicle, 37),
			modHydrolic = GetVehicleMod(vehicle, 38),
			modEngineBlock = GetVehicleMod(vehicle, 39),
			modAirFilter = GetVehicleMod(vehicle, 40),
			modStruts = GetVehicleMod(vehicle, 41),
			modArchCover = GetVehicleMod(vehicle, 42),
			modAerials = GetVehicleMod(vehicle, 43),
			modTrimB = GetVehicleMod(vehicle, 44),
			modTank = GetVehicleMod(vehicle, 45),
			modWindows = GetVehicleMod(vehicle, 46),
			modDoorR = GetVehicleMod(vehicle, 47),
			modLivery = modLivery,
			modLightbar = GetVehicleMod(vehicle, 49)
		}
	end
end

function VehicleSpawn(data, spawn, price)
    ESX.Streaming.RequestModel(data.vehicle.model)
    TriggerServerEvent('luke_garages:SpawnVehicle', data.vehicle.model, data.vehicle.plate, vector3(spawn.x, spawn.y, spawn.z-1), type(spawn) == 'vector4' and spawn.w or spawn.h, price)
end

function IsInsideZone(type, entity)
    local entityCoords = GetEntityCoords(entity)
    if type == 'impound' then
        for k, v in pairs(impounds) do
            if impounds[k]:isPointInside(entityCoords) then
                currentImpound = Config.Impounds[k]
                return true 
            end
            if k == #impounds then return false end
        end
    else
        for k, v in pairs(garages) do
            if garages[k]:isPointInside(entityCoords) then
                currentGarage = Config.Garages[k]
                return true
            end
            if k == #garages then return false end
        end
    end
end

function ImpoundBlips(coords, type, label, blipOptions)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, blipOptions?.sprite or 285)
    SetBlipScale(blip, blipOptions?.scale or 0.8)
    SetBlipColour(blip, blipOptions?.colour and blipOptions.colour or type == 'car' and Config.BlipColors.Car or type == 'boat' and Config.BlipColors.Boat or Config.BlipColors.Aircraft)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label or Locale(type) .. ' ' .. Locale('impound_lot'))
    EndTextCommandSetBlipName(blip)
end

function GarageBlips(coords, type, label, job, blipOptions)
    if job then return end
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, blipOptions?.sprite or 357)
    SetBlipScale(blip, blipOptions?.scale or 0.8)
    SetBlipColour(blip, blipOptions?.colour ~= nil and blipOptions.colour or type == 'car' and Config.BlipColors.Car or type == 'boat' and Config.BlipColors.Boat or Config.BlipColors.Aircraft)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.SplitGarages == true and label or Locale(type) .. ' ' .. Locale('garage'))
    EndTextCommandSetBlipName(blip)
end

local function JobGarageBlip(garage)
    local index = #jobBlips + 1
    local blip = AddBlipForCoord(garage.pedCoords.x, garage.pedCoords.y, garage.pedCoords.z)
    jobBlips[index] = blip
    SetBlipSprite(jobBlips[index], 357)
    SetBlipScale(jobBlips[index], 0.8)
    SetBlipColour(jobBlips[index], garage.type == 'car' and Config.BlipColors.Car or garage.type == 'boat' and Config.BlipColors.Boat or Config.BlipColors.Aircraft)
    SetBlipAsShortRange(jobBlips[index], true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.SplitGarages == true and garage.label or Locale(garage.type) .. ' ' .. Locale('garage'))
    EndTextCommandSetBlipName(jobBlips[index])
end

exports['qtarget']:Vehicle({
	options = {
		{
			event = 'luke_garages:StoreVehicle',
			label = Locale('store_vehicle'),
			icon = 'fas fa-parking',
            canInteract = function(entity)
                hasChecked = false
                if IsInsideZone('garage', entity) and not hasChecked then
                    hasChecked = true
                    return true
                end
            end
		}
	},
	distance = 2.5
})

for k, v in pairs(Config.Garages) do

    GarageBlips(vector3(v.pedCoords.x, v.pedCoords.y, v.pedCoords.z), v.type, v.label, v.job, v.blip)

    garages[k] = BoxZone:Create(
        vector3(v.zone.x, v.zone.y, v.zone.z),
        v.zone.l, v.zone.w, {
            name = v.zone.name,
            heading = v.zone.h,
            debugPoly = false,
            minZ = v.zone.minZ,
            maxZ = v.zone.maxZ
        }
    )

    garages[k].type = v.type
    garages[k].label = v.label

    exports['qtarget']:AddTargetModel({v.ped or Config.DefaultGaragePed}, {
        options = {
            {
                event = "luke_garages:GetOwnedVehicles",
                icon = "fas fa-warehouse",
                label = Locale('take_out_vehicle'),
                job = v.job or nil,
                canInteract = function(entity)
                    hasChecked = false
                    if IsInsideZone('garage', entity) and not hasChecked then
                        hasChecked = true
                        return true
                    end
                end
            },
        },
        distance = 2.5,
    })

    garages[k]:onPlayerInOut(function(isPointInside, point)
        local model = v.ped or Config.DefaultGaragePed
        local heading = type(v.pedCoords) == 'vector4' and v.pedCoords.w or v.pedCoords.h
        if isPointInside then
    
            ESX.Streaming.RequestModel(model)

            ped = CreatePed(0, model, v.pedCoords.x, v.pedCoords.y, v.pedCoords.z, heading, false, true)
            SetEntityAlpha(ped, 0, false)
            Wait(50)
            SetEntityAlpha(ped, 255, false)

            SetPedFleeAttributes(ped, 2)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetPedCanRagdollFromPlayerImpact(ped, false)
            SetPedDiesWhenInjured(ped, false)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetPedCanPlayAmbientAnims(ped, false)
        else
            DeletePed(ped)
        end
    end)
end

local impoundPeds = {Config.DefaultImpoundPed}
for k, v in pairs(Config.Impounds) do

    ImpoundBlips(vector3(v.pedCoords.x, v.pedCoords.y, v.pedCoords.z), v.type, v.label, v.blip)

    impounds[k] = BoxZone:Create(
        vector3(v.zone.x, v.zone.y, v.zone.z),
        v.zone.l, v.zone.w, {
            name = v.zone.name,
            heading = v.zone.h,
            debugPoly = false,
            minZ = v.zone.minZ,
            maxZ = v.zone.maxZ
        }
    )

    impounds[k].type = v.type

    table.insert(impoundPeds, v.ped)

    impounds[k]:onPlayerInOut(function(isPointInside, point)
        local model = v.ped or Config.DefaultImpoundPed
        local heading = type(v.pedCoords) == 'vector4' and v.pedCoords.w or v.pedCoords.h
        if isPointInside then
    
            ESX.Streaming.RequestModel(model)

            ped = CreatePed(0, model, v.pedCoords.x, v.pedCoords.y, v.pedCoords.z, heading, false, true)
            SetEntityAlpha(ped, 0, false)
            Wait(50)
            SetEntityAlpha(ped, 255, false)

            SetPedFleeAttributes(ped, 2)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetPedCanRagdollFromPlayerImpact(ped, false)
            SetPedDiesWhenInjured(ped, false)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetPedCanPlayAmbientAnims(ped, false)
        else
            DeletePed(ped)
        end
    end)
end

exports['qtarget']:AddTargetModel(impoundPeds, {
    options = {
        {
            event = 'luke_garages:GetImpoundedVehicles',
            icon = "fas fa-key",
            label = Locale('access_impound'),
            canInteract = function(entity)
                hasChecked = false
                if IsInsideZone('impound', entity) and not hasChecked then
                    hasChecked = true
                    return true
                end
            end
        },
    },
    distance = 2.5,
})

AddStateBagChangeHandler('vehicledata', nil, function(bagName, key, value, _unused, replicated)
    if not value then return end
    local entNet = bagName:gsub('entity:', '')
    while not NetworkDoesEntityExistWithNetworkId(tonumber(entNet)) do Wait(0) end
    local vehicle = NetToVeh(tonumber(entNet))
    if NetworkGetEntityOwner(vehicle) ~= PlayerId() then return end
    SetVehProperties(vehicle, json.decode(value.vehicle), json.decode(value.health))
end)

RegisterNetEvent('luke_garages:GetImpoundedVehicles')
AddEventHandler('luke_garages:GetImpoundedVehicles', function()
    ESX.TriggerServerCallback('luke_garages:GetImpound', function(vehicles)
        local menu = {}

        TriggerEvent('nh-context:sendMenu', {
            {
                id = 0,
                header = currentImpound.label or Locale(currentImpound.type) .. ' ' .. Locale('impound'),
                txt = ''
            },
        })

        if vehicles ~= nil then
            for k, v in pairs(vehicles) do
                local vehModel = v.vehicle.model
                local vehMake = GetLabelText(GetMakeNameFromVehicleModel(vehModel))
                local vehName = GetLabelText(GetDisplayNameFromVehicleModel(vehModel))
                local vehTitle = vehMake .. ' ' .. vehName
                
                local impoundPrice = Config.ImpoundPrices['' .. GetVehicleClassFromName(vehModel)]

                table.insert(menu, {
                    id = k,
                    header = vehTitle,
                    txt = Locale('plate') .. ': ' .. v.plate,
                    params = {
                        event = 'luke_garages:ImpoundVehicleMenu',
                        args = {name = vehTitle, plate = v.plate, model = vehModel, vehicle = v.vehicle, health = v.health, price = impoundPrice}
                    }
                })
            end
            if #menu ~= 0 then
                TriggerEvent('nh-context:sendMenu', menu)
            else
                TriggerEvent('nh-context:sendMenu', {
                    {
                        id = 1,
                        header = Locale('no_vehicles_impound'),
                        txt = ''
                    }
                })
            end
        else
            TriggerEvent('nh-context:sendMenu', {
                {
                    id = 1,
                    header = Locale('no_vehicles_impound'),
                    txt = ''
                }
            })
        end
    end, currentImpound.type)
end)

--todo: Refactor *everything*
RegisterNetEvent('luke_garages:GetOwnedVehicles')
AddEventHandler('luke_garages:GetOwnedVehicles', function()
    ESX.TriggerServerCallback('luke_garages:GetVehicles', function(vehicles)
        local menu = {}

        TriggerEvent('nh-context:sendMenu', {
            {
                id = 0,
                header = Config.SplitGarages == true and currentGarage.label or Locale(currentGarage.type) .. ' ' .. Locale('garage'),
                txt = ''
            },
        })

        if vehicles ~= nil then
            for k, v in pairs(vehicles) do
                local vehModel = v.vehicle.model
                local vehMake = GetLabelText(GetMakeNameFromVehicleModel(vehModel))
                local vehName = GetLabelText(GetDisplayNameFromVehicleModel(vehModel))
                local vehTitle = vehMake .. ' ' .. vehName
                if Config.SplitGarages then
                    if (v.stored == 1 or v.stored == true) and (v.garage == (currentGarage.zone.name or currentGarage.label) or not v.garage) then
                        table.insert(menu, {
                            id = k,
                            header = vehTitle,
                            txt = Locale('plate') .. ': ' .. v.plate .. ' <br>' .. Locale('in_garage'),
                            params = {
                                event = 'luke_garages:VehicleMenu',
                                args = {name = vehTitle, plate = v.plate, model = vehModel, vehicle = v.vehicle, health = v.health}
                            }  
                        })
                    elseif (v.stored == 1 or v.stored == true) and v.garage ~= currentGarage.zone.name then
                        table.insert(menu, {
                            id = k,
                            header = vehTitle,
                            txt = Locale('plate') .. ': ' .. v.plate .. ' <br>' .. Locale('garage') .. ': ' .. GetGarageLabel(v.garage),
                        })
                    else
                        table.insert(menu, {
                            id = k,
                            header = vehTitle,
                            txt = Locale('plate') .. ': ' .. v.plate .. ' <br>' .. Locale('not_in_garage'),
                        })
                    end
                else
                    if v.stored == 1 or v.stored == true then
                        table.insert(menu, {
                            id = k,
                            header = vehTitle,
                            txt = Locale('plate') .. ': ' .. v.plate .. ' <br>' ..  Locale('in_garage'),
                            params = {
                                event = 'luke_garages:VehicleMenu',
                                args = {name = vehTitle, plate = v.plate, model = vehModel, vehicle = v.vehicle, health = v.health}
                            }
                        })
                    else
                        table.insert(menu, {
                            id = k,
                            header = vehTitle,
                            txt = Locale('plate') .. ': ' .. v.plate .. ' <br>' .. Locale('not_in_garage'),
                        })
                    end
                end
            end
            if #menu ~= 0 then
                TriggerEvent('nh-context:sendMenu', menu)
            else
                TriggerEvent('nh-context:sendMenu', {
                    {
                        id = 1,
                        header = Locale('no_vehicles_garage'),
                        txt = ''
                    }
                })
            end
        else
            TriggerEvent('nh-context:sendMenu', {
                {
                    id = 1,
                    header = Locale('no_vehicles_garage'),
                    txt = '',
                }
            })
        end
    end, currentGarage.type, currentGarage.job)
end)

RegisterNetEvent('luke_garages:ImpoundVehicleMenu')
AddEventHandler('luke_garages:ImpoundVehicleMenu', function(data)
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 0,
            header = Locale('menu_go_back'),
            txt = '',
            params = {
                event = 'luke_garages:GetImpoundedVehicles',
            }
        },
        {
            id = 1,
            header = Locale('take_out_vehicle_impound'),
            txt = Locale('car') .. ': ' .. data.name .. ' <br> ' .. Locale('plate') .. ': ' .. data.plate .. ' <br> ' .. Locale('price') .. ': ' .. Locale('$') .. data.price,
            params = {
                event = 'luke_garages:RequestVehicle',
                args = {
                    vehicle = data.vehicle,
                    health = data.health,
                    price = data.price,
                    type = 'impound'
                }
            }
        }
    })
end)

RegisterNetEvent('luke_garages:VehicleMenu')
AddEventHandler('luke_garages:VehicleMenu', function(data)
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 0,
            header = Locale('menu_go_back'),
            txt = '',
            params = {
                event = 'luke_garages:GetOwnedVehicles'
            }
        },
        {
            id = 1,
            header = Locale('take_out_vehicle'),
            txt = Locale('car') .. ': ' .. data.name .. ' | ' .. Locale('plate') .. ': ' .. data.plate,
            params = {
                event = 'luke_garages:RequestVehicle',
                args = {
                    vehicle = data.vehicle,
                    health = data.health,
                    type = 'garage'
                }
            }
        }
    })
end)

RegisterNetEvent('luke_garages:RequestVehicle')
AddEventHandler('luke_garages:RequestVehicle', function(data)
    local spawn = nil

    if data.type == 'garage' then
        spawn = currentGarage.spawns
    else
        spawn = currentImpound.spawns
    end

    for i = 1, #spawn do
        if ESX.Game.IsSpawnPointClear(vector3(spawn[i].x, spawn[i].y, spawn[i].z), 1.0) then
            return VehicleSpawn(data, spawn[i], data.type == 'impound' and data.price or nil)
        end
        if i == #spawn then ESX.ShowNotification(Locale('no_spawn_spots')) end
    end
end)

RegisterNetEvent('luke_garages:StoreVehicle')
AddEventHandler('luke_garages:StoreVehicle', function(target)
    local health = {}
    local brokenParts = {
        windows = {},
        tires = {},
        doors = {}
    }

    local vehicle = target.entity
    local vehPlate = GetVehicleNumberPlateText(vehicle)

    for window = 0, 7 do 
        if not IsVehicleWindowIntact(vehicle, window) then
            table.insert(brokenParts.windows, window)
        end
    end

    for index = 0, 5 do
        if IsVehicleTyreBurst(vehicle, index, false) then
            table.insert(brokenParts.tires, index)
        end
        if IsVehicleDoorDamaged(vehicle, index) then
            table.insert(brokenParts.doors, index)
        end
    end

    health.body = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 2)
    health.engine = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 2)
    health.parts = brokenParts
    health.fuel = ESX.Math.Round(GetVehicleFuelLevel(vehicle), 2)
    local ent = Entity(vehicle)
    if ent.state.fuel ~= nil then
        health.fuel = ESX.Math.Round(ent.state.fuel, 2)
    end

    local vehProps = getVehProperties(vehicle)

    ESX.TriggerServerCallback('luke_garages:CheckOwnership', function(doesOwn)
        if doesOwn then
            if type(doesOwn) == 'table' then return ESX.ShowNotification("You can't store this vehicle here") end

            TriggerServerEvent('luke_garages:ChangeStored', vehPlate, true, currentGarage.zone.name)

            TriggerServerEvent('luke_garages:SaveVehicle', vehProps, health, vehPlate, VehToNet(vehicle))
        else
            ESX.ShowNotification(Locale('no_ownership'))
        end
    end, vehPlate, vehProps.model, currentGarage.job)

end)

RegisterNetEvent('esx:setJob', function(job)
    for i = 1, #jobBlips do RemoveBlip(jobBlips[i]) end
    for i = 1, #Config.Garages do
        if Config.Garages[i].job == job.name then JobGarageBlip(Config.Garages[i]) end
    end
end)