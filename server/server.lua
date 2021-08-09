ESX.RegisterServerCallback('luke_vehiclegarage:GetVehicles', function(source, callback, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local vehicles = {}

    MySQL.Async.fetchAll('SELECT * FROM `owned_vehicles` WHERE `owner` = @identifier AND `type` = @type', {
        ['@identifier'] = identifier,
        ['@type'] = type
    }, function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                local veh = json.decode(v.vehicle)
                local health = json.decode(v.health)
                table.insert(vehicles, {plate = v.plate, vehicle = veh, stored = v.stored, health = health})
            end
            callback(vehicles)
        else
            callback(nil)
        end
    end)
end)

ESX.RegisterServerCallback('luke_vehiclegarage:GetImpound', function(source, callback, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local vehicles = {}

    MySQL.Async.fetchAll('SELECT * FROM `owned_vehicles` WHERE `owner` = @identifier AND `type` = @type AND `stored` = 0', {
        ['@identifier'] = identifier,
        ['@type'] = type,
    }, function(results)
        if results[1] ~= nil then
            for k, v in pairs(results) do
                local veh = json.decode(v.vehicle)
                local health = json.decode(v.health)
                table.insert(vehicles, {plate = v.plate, vehicle = veh, health = health})
            end
            callback(vehicles)
        else
            callback(nil)
        end
    end)
end)

ESX.RegisterServerCallback('luke_vehiclegarage:CheckOwnership', function(source, callback, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    local plate = ESX.Math.Trim(plate)

    MySQL.Async.fetchScalar('SELECT 1 FROM `owned_vehicles` WHERE `owner` = @owner AND `plate` = @plate', {
        ['@owner'] = identifier,
        ['@plate'] = plate
    }, function(result)
        if result then
            callback(true)
        else
            callback(false)
        end
    end)
end)

RegisterNetEvent('luke_vehiclegarage:ChangeStored')
AddEventHandler('luke_vehiclegarage:ChangeStored', function(plate, stored)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if stored then 
        stored = 1 
    else 
        stored = 0 
    end

    local plate = ESX.Math.Trim(plate)


    MySQL.Async.execute('UPDATE `owned_vehicles` SET `stored` = @stored WHERE `plate` = @plate', {
        ['@stored'] = stored,
        ['@plate'] = plate
    }, function(rowsChanged)
    end)
end)

RegisterNetEvent('luke_vehiclegarage:SaveVehicle')
AddEventHandler('luke_vehiclegarage:SaveVehicle', function(vehicle, health, plate)
    MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle, `health` = @health WHERE `plate` = @plate', {
        ['@health'] = json.encode(health),
        ['@vehicle'] = json.encode(vehicle),
        ['@plate'] = plate
    }, function(rowsChanged)
        
    end)
end)

RegisterNetEvent('luke_vehiclegarage:PayImpound')
AddEventHandler('luke_vehiclegarage:PayImpound', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if Config.PayInCash then
            if xPlayer.getMoney() >= amount then
                xPlayer.removeMoney(amount)
            else
                return xPlayer.showNotification("You don't have enough money on you.")
            end
        else
            if xPlayer.getAccount('bank').money >= amount then
                xPlayer.removeAccountMoney('bank', amount)
            else
                return xPlayer.showNotification("You don't have enough money in your bank.")
            end
        end
    end
end)

ESX.RegisterServerCallback('luke_vehiclegarage:SpawnVehicle', function(source, callback, model, coords, heading)
    if type(model) == 'string' then model = GetHashKey(model) end
    Citizen.CreateThread(function()
        entity = CreateVehicle(model, coords, heading, true, true)
        while not DoesEntityExist(entity) do Wait(20) end
        netid = NetworkGetNetworkIdFromEntity(entity)
        callback(netid)
    end)
end)