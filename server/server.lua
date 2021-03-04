ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

StoreVehiclesOnResourceStart = false -- Set this to false if you don't want it

-- On script restart (or server start) all vehicles are going to be stored into the garage by default
if StoreVehiclesOnResourceStart == true then
    MySQL.ready(function()
        MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE `stored` = false', {
            ['@stored'] = true
        }, function()
        end)
    end)
end

-- Server callback that fetches the cars the player owns based on their steam identifier
ESX.RegisterServerCallback('luke_vehiclegarage:FetchOwnedCars', function(source, callback)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local ownedCars = {}

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `owner` = @owner AND `type` = @type', {
        ['@owner'] = xPlayer.identifier,
        ['@type'] = 'car'
    }, function(data)
        for k, v in pairs(data) do
            local car = json.decode(v.vehicle)
            table.insert(ownedCars, {vehicle = car, plate = v.plate, stored = v.stored})
        end
        callback(ownedCars)
    end)
end)

-- Server callback that fetches the boats the player owns based on their steam identifier
ESX.RegisterServerCallback('luke_vehiclegarage:FetchOwnedBoats', function(source, callback)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local ownedBoats = {}

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `owner` = @owner AND `type` = @type', {
        ['@owner'] = xPlayer.identifier,
        ['@type'] = 'boat',
    }, function(data)
        for k, v in pairs(data) do
            local boat = json.decode(v.vehicle)
            table.insert(ownedBoats, {vehicle = boat, plate = v.plate, stored = v.stored})
        end
        callback(ownedBoats)
    end)
end)

-- Server callback that fetches the aircrafts the player owns based on their steam identifier
ESX.RegisterServerCallback('luke_vehiclegarage:FetchOwnedAircrafts', function(source, callback)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local ownedAircrafts = {}

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `owner` = @owner AND `type` = @type', {
        ['@owner'] = xPlayer.identifier,
        ['@type'] = 'aircraft',
    }, function(data)
        for k, v in pairs(data) do
            local aircraft = json.decode(v.vehicle)
            table.insert(ownedAircrafts, {vehicle = aircraft, plate = v.plate, stored = v.stored})
        end
        callback(ownedAircrafts)
    end)
end)

-- Server callback to check whether the player owns the vehicle or not
ESX.RegisterServerCallback('luke_vehiclegarage:CheckOwnership', function(source, callback, vehiclePlate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `owner` = @owner AND `plate` = @plate', {
        ['@owner'] = xPlayer.identifier,
        ['@plate'] = vehiclePlate,
    }, function(data)
        if data[1] ~= nil then
            local playerVehicle = true
            callback(playerVehicle)
        else
            playerVehicle = false
            callback(playerVehicle)
        end
    end)
end)

-- Callback that checks the player money
ESX.RegisterServerCallback('luke_vehiclegarage:ChargePlayer', function(source, callback)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer ~= nil then
        if Config.UseCash == true then
            if xPlayer.getMoney() >= Config.ImpoundPrice then
                xPlayer.removeMoney(Config.ImpoundPrice)
                TriggerClientEvent('esx:showNotification', src, 'You were charged ~r~$'..Config.ImpoundPrice)
                callback(true)
            else
                callback(false)
            end
        else
            if xPlayer.getAccount('bank').money >= Config.ImpoundPrice then
                xPlayer.removeAccountMoney('bank', Config.ImpoundPrice)
                TriggerClientEvent('esx:showNotification', src, 'You were charged ~r~$'..Config.ImpoundPrice)
                callback(true)
            else
                callback(false)
            end
        end
    end
end)

-- Event that saves the damage to the vehicle
RegisterNetEvent('luke_vehiclegarage:SaveVehicleDamage')
AddEventHandler('luke_vehiclegarage:SaveVehicleDamage', function(vehicle)
   MySQL.Async.execute('UPDATE owned_vehicles SET `vehicle` = @vehicle WHERE `plate` = @plate', {
        ['@vehicle'] = json.encode(vehicle),
        ['@plate'] = vehicle.plate,
    }, function(data)
    end)
end)

-- Event that updates whether the vehicle has been stored into the garage or not
RegisterNetEvent('luke_vehiclegarage:VehicleStatus')
AddEventHandler('luke_vehiclegarage:VehicleStatus', function(vehiclePlate, stored)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE `plate` = @plate', {
        ['@stored'] = stored,
        ['@plate'] = vehiclePlate,
    }, function(data)
        if data == 0 then
            print('luke_vehiclegarage: No values changed') 
        end
    end)
end)