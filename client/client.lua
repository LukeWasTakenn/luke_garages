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

function DoVehicleDamage(vehicle, health)
    if health ~= nil then
        Citizen.Wait(1500)
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
    else
        return
    end
end

function VehicleSpawn(data, spawn)
    TriggerServerEvent('luke_garages:SpawnVehicle', data.vehicle.model, data.vehicle.plate, vector3(spawn.x, spawn.y, spawn.z-1), type(spawn) == 'vector4' and spawn.w or spawn.h)
    if data.type == 'impound' then TriggerServerEvent('luke_garages:PayImpound', data.price) end
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

    if not blipOptions?.colour then
        if type == 'car' then
            SetBlipColour(blip, Config.BlipColors.Car)
        elseif type == 'boat' then
            SetBlipColour(blip, Config.BlipColors.Boat)
        elseif type == 'aircraft' then
            SetBlipColour(blip, Config.BlipColors.Aircraft)
        end
    else SetBlipColour(blip, blipOptions.colour) end

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

    if not blipOptions?.colour then
        if type == 'car' then
            SetBlipColour(blip, Config.BlipColors.Car)
        elseif type == 'boat' then
            SetBlipColour(blip, Config.BlipColors.Boat)
        elseif type == 'aircraft' then
            SetBlipColour(blip, Config.BlipColors.Aircraft)
        end
    else SetBlipColour(blip, blipOptions.colour) end

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

    if garage.type == 'car' then
        SetBlipColour(jobBlips[index], Config.BlipColors.Car)
    elseif garage.type == 'boat' then
        SetBlipColour(jobBlips[index], Config.BlipColors.Boat)
    elseif garage.type == 'aircraft' then
        SetBlipColour(jobBlips[index], Config.BlipColors.Aircraft)
    end

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

Citizen.CreateThread(function()
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
end)

Citizen.CreateThread(function()
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
end)

RegisterNetEvent('luke_garages:SetVehicleMods', function(netId, svData)
    while not NetworkDoesEntityExistWithNetworkId(netId) do Wait(25) end
    vehicle = NetToVeh(netId)
    ESX.Game.SetVehicleProperties(vehicle, json.decode(svData.vehicle))
    TriggerServerEvent('luke_garages:ChangeStored', svData.plate, false)
    DoVehicleDamage(vehicle, json.decode(svData.health))
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
            if data.type == 'impound' then
                ESX.TriggerServerCallback('luke_garages:PayImpound', function(canAfford)
                    if canAfford then VehicleSpawn(data, spawn[i]) end
                end, data.price)
            else VehicleSpawn(data, spawn[i]) end break
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

    local vehProps = ESX.Game.GetVehicleProperties(vehicle)

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