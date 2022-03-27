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

AddStateBagChangeHandler('vehicleData', nil, function(bagName, key, value, _unused, replicated)
    if not value then return end
    local entNet = bagName:gsub('entity:', '')
    while not NetworkDoesEntityExistWithNetworkId(tonumber(entNet)) do Wait(0) end
    local vehicle = NetToVeh(tonumber(entNet))
    if NetworkGetEntityOwner(vehicle) ~= PlayerId() then return end
    SetVehProperties(vehicle, json.decode(value.vehicle), json.decode(value.health))
    TriggerServerEvent('luke_garages:ChangeStored', value.plate, false, nil)
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
            if type(doesOwn) == 'table' then return ESX.ShowNotification(Locale('garage_cant_store') end

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
