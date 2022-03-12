RegisterNetEvent('luke_garages:ThrowError', function(text)
    error(text)
end)

if Config.RestoreVehicles then
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE owned_vehicles SET stored = 1, garage = @garage WHERE stored = 0", {
            ['@garage'] = Config.DefaultGarage
        })
    end)
end

ESX.RegisterServerCallback('luke_garages:GetVehicles', function(source, callback, type, job)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local vehicles = {}

    if not job then
        MySQL.Async.fetchAll("SELECT plate, vehicle, stored, health, garage, job FROM owned_vehicles WHERE owner = @identifier AND type = @type", {
            ['@identifier'] = identifier,
            ['@type'] = type
        }, function(result)
            if result[1] ~= nil then
                for k, v in pairs(result) do
                    if not v.job or v.job == 'civ' then
                        local veh = json.decode(v.vehicle)
                        local health = json.decode(v.health)
                        table.insert(vehicles, {plate = v.plate, vehicle = veh, stored = v.stored, health = health, garage = v.garage})
                    end
                end
                callback(vehicles)
            else
                callback(nil)
            end
        end)
    else
        MySQL.Async.fetchAll('SELECT plate, vehicle, stored, health, garage FROM owned_vehicles WHERE (owner = @identifier OR owner = @job) AND type = @type AND job = @job', {
            ['@identifier'] = identifier,
            ['@type'] = type,
            ['@job'] = job
        }, function(result)
            if result[1] ~= nil then
                for k, v in pairs(result) do
                    local veh = json.decode(v.vehicle)
                    local health = json.decode(v.health)
                    table.insert(vehicles, {plate = v.plate, vehicle = veh, stored = v.stored, health = health, garage = v.garage})
                end
                callback(vehicles)
            else
                callback(nil)
            end
        end)
    end
end)

ESX.RegisterServerCallback('luke_garages:GetImpound', function(source, callback, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local vehicles = {}

    local worldVehicles = GetAllVehicles()

    MySQL.Async.fetchAll('SELECT plate, vehicle, health, job FROM owned_vehicles WHERE (owner = @identifier OR owner = @job) AND type = @type AND stored = 0', {
        ['@identifier'] = identifier,
        ['@type'] = type,
        ['@job'] = xPlayer.job.name
    }, function(results)
        if results[1] ~= nil then
            for k, v in pairs(results) do
                local veh = json.decode(v.vehicle)
                local health = json.decode(v.health)
                for index, vehicle in pairs(worldVehicles) do
                    if ESX.Math.Trim(v.plate) == ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)) then
                        break
                    elseif index == #worldVehicles then
                        -- Allows players to only get their job vehicle from impound while having the job
                        if (v.job == 'civ' or v.job == nil) or v.job == xPlayer.job.name then
                            table.insert(vehicles, {plate = v.plate, vehicle = veh, health = health})
                        end
                    end
                end
            end
            callback(vehicles)
        else
            callback(nil)
        end
    end)
end)

ESX.RegisterServerCallback('luke_garages:CheckOwnership', function(source, callback, plate, model, job)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    local plate = ESX.Math.Trim(plate)

    MySQL.Async.fetchAll('SELECT vehicle, job FROM owned_vehicles WHERE (owner = @owner OR job = @job) AND plate = @plate', {
        ['@owner'] = identifier,
        ['@plate'] = plate,
        ['@job'] = xPlayer.job.name
    }, function(result)
        if result[1] then
            local vehicle = json.decode(result[1].vehicle)
            local vehicleJob = result[1].job
            if vehicle.plate == plate and vehicle.model == model then
                if not job and not vehicleJob or vehicleJob == 'civ' then return callback(true) end
                if job and job == vehicleJob then return callback(true)
                else return callback({true, false}) end
            else
                -- Player tried to cheat
                callback(false)
            end
        else
            callback(false)
        end
    end)
end)

RegisterNetEvent('luke_garages:ChangeStored')
AddEventHandler('luke_garages:ChangeStored', function(plate, stored, garage)
    if stored then stored = 1 else stored = 0 garage = 'none' end

    local plate = ESX.Math.Trim(plate)

    MySQL.Async.execute('UPDATE owned_vehicles SET stored = @stored, garage = @garage WHERE plate = @plate', {
        ['@garage'] = garage,
        ['@stored'] = stored,
        ['@plate'] = plate
    })
end)

RegisterNetEvent('luke_garages:SaveVehicle')
AddEventHandler('luke_garages:SaveVehicle', function(vehicle, health, plate, ent)
    DeleteEntity(NetworkGetEntityFromNetworkId(ent))
    MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle, health = @health WHERE plate = @plate', {
        ['@health'] = json.encode(health),
        ['@vehicle'] = json.encode(vehicle),
        ['@plate'] = ESX.Math.Trim(plate)
    })
end)

local function canAfford(price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if Config.PayInCash then
            if xPlayer.getMoney() >= price then
                return true
            else
                xPlayer.showNotification(Locale('no_money_cash'))
                return false
            end
        else
            if xPlayer.getAccountMoney('bank') >= price then
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
    if price and not canAfford(price) then return end
    for i = 1, #vehicles do
        if ESX.Math.Trim(GetVehicleNumberPlateText(vehicles[i])) == plate then return xPlayer.showNotification(Locale('vehicle_already_exists')) end
    end
    Citizen.CreateThread(function()
        local entity = Citizen.InvokeNative(`CREATE_AUTOMOBILE`, model, coords.x, coords.y, coords.z, heading)
        Wait(50)
        local netId = NetworkGetNetworkIdFromEntity(entity)
        local entityOwner = NetworkGetEntityOwner(entity)
        -- Sometimes peds can spawn inside vehicles
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
        MySQL.Async.fetchAll('SELECT vehicle, plate, health FROM owned_vehicles WHERE plate = @plate', {['@plate'] = ESX.Math.Trim(plate)}, function(result)
            if result[1] then TriggerClientEvent('luke_garages:SetVehicleMods', entityOwner, netId, result[1]) end
        end)
    end)
end)
