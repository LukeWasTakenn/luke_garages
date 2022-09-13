RegisterNetEvent('luke_garages:ThrowError', function(text)
    error(text)
end)

if Config.EnableVersionCheck then lib.versionCheck('lukewastakenn/luke_garages') end

if Config.RestoreVehicles then
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE `owned_vehicles` SET `stored` = 1, `garage` = `last_garage` WHERE `stored` = 0")
    end)
end

lib.callback.register('luke_garages:GetVehicles', function(source, garageType, job)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local vehicles = {}

    if not job then
        local results = MySQL.Sync.fetchAll("SELECT `plate`, `vehicle`, `stored`, `garage`, `job` FROM `owned_vehicles` WHERE `owner` = @identifier AND `type` = @type", {
            ['@identifier'] = identifier,
            ['@type'] = garageType
        })
        if results[1] ~= nil then
            for i = 1, #results do
                local result = results[i]
                if not result.job or result.job == 'civ' then
                    local veh = json.decode(result.vehicle)
                    vehicles[#vehicles+1] = {plate = result.plate, vehicle = veh, stored = result.stored, garage = result.garage}
                end
            end

            return vehicles
        end
    else
        local jobs = {}
        if type(job) == 'table' then for k, _ in pairs(job) do jobs[#jobs+1] = k end else jobs = job end
        local results = MySQL.Sync.fetchAll('SELECT `plate`, `vehicle`, `stored`, `garage` FROM `owned_vehicles` WHERE (`owner` = @identifier OR `owner` IN (@jobs)) AND `type` = @type AND `job` IN (@jobs)', {
            ['@identifier'] = identifier,
            ['@type'] = garageType,
            ['@jobs'] = jobs
        })
        if results[1] ~= nil then
            for i = 1, #results do
                local result = results[i]
                local veh = json.decode(result.vehicle)
                vehicles[#vehicles+1] = {plate = result.plate, vehicle = veh, stored = result.stored, garage = result.garage}
            end

            return vehicles
        end
    end
end)

lib.callback.register('luke_garages:GetImpound', function(source, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local vehicles = {}

    local worldVehicles = GetAllVehicles()

    local results = MySQL.Sync.fetchAll('SELECT `plate`, `vehicle`, `job` FROM owned_vehicles WHERE (`owner` = @identifier OR `owner` = @job) AND `type` = @type AND `stored` = 0', {
        ['@identifier'] = identifier,
        ['@type'] = type,
        ['@job'] = xPlayer.job.name
    })
    if results[1] ~= nil then
        for i = 1, #results do
            local result = results[i]
            local veh = json.decode(result.vehicle)
            if #worldVehicles ~= nil and #worldVehicles > 0 then
                for index = 1, #worldVehicles do
                    local vehicle = worldVehicles[index]
                    if ESX.Math.Trim(result.plate) == ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)) then
                        if GetVehiclePetrolTankHealth(vehicle) > 0 and GetVehicleBodyHealth(vehicle) > 0 then break end
                        if GetVehiclePetrolTankHealth(vehicle) <= 0 and GetVehicleBodyHealth(vehicle) <= 0 then DeleteEntity(vehicle)
                            -- Allows players to only get their job vehicle from impound while having the job
                            if (result.job == 'civ' or result.job == nil) or result.job == xPlayer.job.name then
                                vehicles[#vehicles+1] = {plate = result.plate, vehicle = veh}
                            end
                        end
                        break
                    elseif index == #worldVehicles then
                        -- Allows players to only get their job vehicle from impound while having the job
                        if (result.job == 'civ' or result.job == nil) or result.job == xPlayer.job.name then
                            vehicles[#vehicles+1] = {plate = result.plate, vehicle = veh}
                        end
                    end
                end
            else
                if (result.job == 'civ' or result.job == nil) or result.job == xPlayer.job.name then
                    vehicles[#vehicles+1] = {plate = result.plate, vehicle = veh}
                end
            end
        end

        return vehicles
    end
end)

lib.callback.register('luke_garages:CheckOwnership', function(source, plate, model, currentGarage)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local job = currentGarage.job

    plate = ESX.Math.Trim(plate)

    local jobs = {}
    if type(job) == 'table' then for k, _ in pairs(job) do jobs[#jobs+1] = k end else jobs = job end
    local result = MySQL.Sync.fetchAll("SELECT `vehicle`, `job`, `type` FROM owned_vehicles WHERE (`owner` = @owner OR `job` IN (@jobs)) AND `plate` = @plate", {
        ['@owner'] = identifier,
        ['@plate'] = ESX.Math.Trim(plate),
        ['@jobs'] = jobs
    })

    if result[1] then
        local vehicle = json.decode(result[1].vehicle)
        local vehicleJob = result[1].job
        if ESX.Math.Trim(vehicle.plate) == plate and vehicle.model == model then
            if currentGarage.type ~= result[1].type then return true, true end
            if not job and not vehicleJob or vehicleJob == 'civ' then return true end
            if job then
                if type(jobs) == 'table' then
                    for i = 1, #jobs do
                        if jobs[i] == vehicleJob then return true end
                        if i == #jobs then return true, true end
                    end
                else
                    if job == vehicleJob then
                        return true
                    else
                        return true, true
                    end
                end
            else if vehicleJob ~= 'civ' then return true, true end end
        else
            -- Player tried to cheat
            return false
        end
    end
end)

RegisterNetEvent('luke_garages:ChangeStored', function(plate)
    local plate = ESX.Math.Trim(plate)
    MySQL.Async.execute('UPDATE `owned_vehicles` SET `stored` = @stored, `garage` = @garage WHERE `plate` = @plate', {
        ['@garage'] = 'none',
        ['@stored'] = 0,
        ['@plate'] = plate
    })
end)

RegisterNetEvent('luke_garages:SaveVehicle', function(vehicle, plate, ent, garage)
    MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle, `garage` = @garage, `last_garage` = @garage, `stored` = @stored WHERE `plate` = @plate', {
        ['@vehicle'] = json.encode(vehicle),
        ['@plate'] = ESX.Math.Trim(plate),
        ['@stored'] = 1,
        ['@garage'] = garage
    })
    local ent = NetworkGetEntityFromNetworkId(ent)
    DeleteEntity(ent)
end)


local function canAfford(src, price)
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        if Config.PayInCash then
            if xPlayer.getMoney() >= price then
                xPlayer.removeMoney(price)
                return true
            else
                xPlayer.showNotification(Locale('no_money_cash'))
                return false
            end
        else
            if xPlayer.getAccount('bank').money >= price then
                xPlayer.removeAccountMoney('bank', price)
                return true
            else
                xPlayer.showNotification(Locale('no_money_bank'))
                return false
            end
        end
    end
end

RegisterNetEvent('luke_garages:SpawnVehicle', function(model, plate, coords, heading, price)
    if type(model) == 'string' then model = GetHashKey(model) end
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicles = GetAllVehicles()
    plate = ESX.Math.Trim(plate)
    if price and not canAfford(source, price) then return end
    for i = 1, #vehicles do
        if ESX.Math.Trim(GetVehicleNumberPlateText(vehicles[i])) == plate then
            if GetVehiclePetrolTankHealth(vehicle) > 0 and GetVehicleBodyHealth(vehicle) > 0 then
            return xPlayer.showNotification(Locale('vehicle_already_exists')) end
        end
    end
    MySQL.Async.fetchAll('SELECT vehicle, plate, garage FROM `owned_vehicles` WHERE plate = @plate', {['@plate'] = ESX.Math.Trim(plate)}, function(result)
        if result[1] then
            CreateThread(function()
                local entity = Citizen.InvokeNative(`CREATE_AUTOMOBILE`, model, coords.x, coords.y, coords.z, heading)
                local ped = GetPedInVehicleSeat(entity, -1)
                if ped > 0 then
                    for i = -1, 6 do
                        ped = GetPedInVehicleSeat(entity, i)
                        local popType = GetEntityPopulationType(ped)
                        if popType <= 5 or popType >= 1 then
                            DeleteEntity(ped)
                        end
                    end
                end
                if Config.TeleportToVehicle then
                    local playerPed = GetPlayerPed(xPlayer.source)
                    local timer = GetGameTimer()
                    while GetVehiclePedIsIn(playerPed) ~= entity do
                        Wait(0)
                        SetPedIntoVehicle(playerPed, entity, -1)
                        if timer - GetGameTimer() > 15000 then
                            break
                        end
                    end
                end
                local ent = Entity(entity)
                ent.state.vehicleData = result[1]
            end)
        end
    end)
end)
