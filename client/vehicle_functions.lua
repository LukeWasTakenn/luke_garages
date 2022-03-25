function getVehProperties(vehicle)
	if DoesEntityExist(vehicle) then
        local ent = Entity(vehicle)
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        local customPrimaryColor, customSecondaryColor = nil, nil

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

function SetVehProperties(vehicle, props, health)
    if DoesEntityExist(vehicle) then
        local ent = Entity(vehicle)
        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        if Config.lockdoors then SetVehicleDoorsLocked(vehicle, 2) end
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
    end
end