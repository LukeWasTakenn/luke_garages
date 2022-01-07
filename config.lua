Config = {}

Config.Locale = 'en'

Config.EnableVersionCheck = true -- If set to true you'll get a print in server console when your resource is out of date
Config.VersionCheckInterval = 60 -- in minutes

-- Puts all vehicles in garage on resource start
-- If using split garages will set all vehicles into the first one in the Config.Garages table
Config.RestoreVehicles = false

-- Default garage zone name the vehicles will be restored to
-- Ignore if not using split garages
Config.DefaultGarage = 'legion'

-- Setting to true will only allow you take out the vehicle from a garage you put it in
Config.SplitGarages = false

Config.DefaultGaragePed = `s_m_y_airworker`
Config.DefaultImpoundPed = `s_m_y_construct_01`

Config.BlipColors = {
    Car = 3,
    Boat = 51,
    Aircraft = 81
}

Config.ImpoundPrices = {
    -- These are vehicle classes
    ['0'] = 300, -- Compacts
    ['1'] = 500, -- Sedans
    ['2'] = 500, -- SUVs
    ['3'] = 800, -- Coupes
    ['4'] = 1200, -- Muscle
    ['5'] = 800, -- Sports Classics
    ['6'] = 1500, -- Sports
    ['7'] = 2500, -- Super
    ['8'] = 300, -- Motorcycles
    ['9'] = 500, -- Off-road
    ['10'] = 1000, -- Industrial
    ['11'] = 500, -- Utility
    ['12'] = 600, -- Vans
    ['13'] = 100, -- Cylces
    ['14'] = 2800, -- Boats
    ['15'] = 3500, -- Helicopters
    ['16'] = 3800, -- Planes
    ['17'] = 500, -- Service
    ['18'] = 0, -- Emergency
    ['19'] = 100, -- Military
    ['20'] = 1500, -- Commercial
    ['21'] = 0 -- Trains (lol)
}

Config.PayInCash = true -- whether you want to pay impound price in cash, otherwise uses bank

Config.Impounds = {
    {
        type = 'car', -- car, boat or aircraft
        pedCoords = {x = 409.25, y = -1623.08, z = 28.29, h = 228.84},
        zone = {name = 'innocence', x = 408.02, y = -1637.08, z = 29.29, l = 31.6, w = 26.8, h = 320, minZ = 28.29, maxZ = 32.29}, -- The zone is only here for the ped to not have the impound option everywhere in the world
        spawns = {
            {x = 416.83, y = -1628.29, z = 29.11, h = 140.43}, 
            {x = 419.58, y = -1629.71, z = 29.11, h = 141.98},
            {x = 421.17, y = -1636.00, z = 29.11, h = 88.21},
            {x = 420.05, y = -1638.93, z = 29.11, h = 88.95},
        }
    },
    {
        type = 'boat',
        pedCoords = {x = -462.92, y = -2443.44, z = 5.00, h = 322.40},
        zone = {name = 'lsboat impound', x = -451.72, y = -2440.42, z = 6.0, l = 22.6, w = 29.4, h = 325, minZ = 5.0, maxZ = 9.0},
        spawns = {
            {x = -493.48, y = -2466.38, z = -0.06, h = 142.26}, 
            {x = -471.09, y = -2483.94, z = 0.28, h = 152.74},
        }
    },
    {
        type = 'aircraft',
        pedCoords = {x = 1758.29, y = 3297.50, z = 40.15, h = 148.27},
        zone = {name = 'sandy air', x = 1757.71, y = 3296.72, z = 41.15, l = 14.4, w = 18.0, h = 50, minZ = 40.13, maxZ = 44.13},
        spawns = {
            {x = 1753.72, y = 3272.12, z = 41.99, h = 105.71},
            {x = 1746.85, y = 3252.57, z = 42.30, h = 105.58},
        }
    },
    --[[
        TEMPLATE:
        {
            type = 'car', - can be 'car', 'boat' or 'aircraft',
            ped = `ped_model_name` -- Define the model model you want to use for the impound (Optional)
            pedCoords = {x = X, y = X, z = X, h = X}, -- Ped MUST be inside the create zone
            zone = {name = 'somename', x = X, y = X, z = X, l = X, w = X, h = X, minZ = X, maxZ = x}, -- l is length of the box zone, w is width, h is heading, take all walues from generated zone from /pzcreate
            spawns = { -- You can have as many as you'd like
                {x = X, y = X, z = X, h = X},
                {x = X, y = X, z = X, h = X}
            }
        },
    ]]
}

Config.Garages = {
    {
        label = 'MRPD Police Garage',
        type = 'car',
        job = 'police',
        ped = `s_m_y_cop_01`,
        pedCoords = {x = 450.6633, y = -1027.3324, z = 27.5732, h = 5.1321},
        zone = {name = 'mrpd', x = 439.36, y= -1021.04, z = 28.83, l = 20, w = 40, h = 0, minZ = 27.03, maxZ = 31.03},
        spawns = {
            {x = 446.4181, y = -1026.2117, z = 28.2490, h = 357.9764},
            {x = 442.5637, y = -1025.5530, z = 28.2984, h = 1.7611},
            {x = 438.6664, y = -1027.0088, z = 28.3936, h = 3.1104},
            {x = 434.8707, y = -1026.6675, z = 28.4554, h = 3.9030},
            {x = 431.6170, y = -1026.7904, z = 28.5088, h = 0.9789},
            {x = 427.3045, y = -1027.6506, z = 28.5950, h = 5.8251}
        }
    },
    {
        label = 'Pillbox Ambulance Garage',
        type = 'car',
        job = 'ambulance',
        ped = `s_m_m_doctor_01`,
        pedCoords = {x = 319.3737, y = -559.4569, z = 27.7438, h = 21.0252},
        zone = {name = 'pillbox', x = 325.59, y = -549.27, z = 28.74, l = 25, w = 25, h = 0, minZ = 27.74, maxZ = 30.74},
        spawns = {
            {x = 321.0445, y = -542.4713, z = 28.5142, h = 180.9354},
            {x = 323.8813, y = -542.8687, z = 28.5135, h = 181.6986},
            {x = 326.6019, y = -542.6691, z = 28.5133, h = 179.8377},
            {x = 329.3755, y = -542.5102, z = 28.5137, h = 179.7974},
            {x = 332.2085, y = -542.5237, z = 28.5125, h = 181.5656}
        }
    },
    {
        label = 'Legion Garage',
        type = 'car', -- car, boat or aircraft
        pedCoords = {x = 215.90, y = -808.87, z = 29.74, h = 248.0}, -- The Ped MUST be inside the PolyZone
        zone = {name = 'legion', x = 228.68, y = -789.15, z = 30.59, l = 52.4, w = 39.6, h = 340, minZ = 28.99, maxZ = 32.99},
        spawns = {
            {x = 206.25, y = -801.21, z = 31.00, h = 250.47},
            {x = 208.72, y = -796.45, z = 30.95, h = 246.74},
            {x = 210.89, y = -791.42, z = 30.90, h = 248.02},
            {x = 216.12, y = -801.68, z = 30.80, h = 68.72},
            {x = 218.21, y = -796.79, z = 30.77, h = 68.80},
            {x = 219.76, y = -791.47, z = 30.76, h = 69.89},
            {x = 221.37, y = -786.53, z = 30.78, h = 70.72},
            {x = 212.52, y = -783.46, z = 30.89, h = 248.63},
        }
    },
    {
        label = 'Americano Way Garage',
        type = 'car',
        pedCoords = {x = -1651.83, y = 63.90, z = 61.86, h = 338.03},
        zone = {name = 'americano', x = -1682.74, y = 60.93, z = 63.5, l = 59.6, w = 60.6, h = 329, minZ = 61.15, maxZ = 68.35},
        spawns = {
            {x = -1660.57, y = 75.52, z = 63.20, h = 170.90},
            {x = -1666.24, y = 79.84, z = 63.45, h = 171.92},
            {x = -1671.97, y = 84.59, z = 63.83, h = 169.94},
            {x = -1662.57, y = 57.99, z = 62.90, h = 293.91},
            {x = -1664.75, y = 60.63, z = 63.05, h = 292.60},
            {x = -1667.53, y = 62.90, z = 63.21, h = 291.82},
        }
    },
    {
        label = 'Route 68 Garage',
        type = 'car',
        pedCoords = {x = 587.23, y = 2723.50, z = 41.13, h = 7.85},
        zone = {name = 'route68', x = 573.19, y = 2727.17, z = 42.06, l = 22.4, w = 51.2, h = 4, minZ = 41.08, maxZ = 45.08},
        Spawns = {
            {x = 584.51, y = 2721.56, z = 41.88, h = 3.59},
            {x = 581.14, y = 2721.32, z = 41.88, h = 3.99},
            {x = 578.15, y = 2720.59, z = 41.88, h = 4.65},
            {x = 574.86, y = 2721.09, z = 41.88, h = 4.85},
            {x = 572.01, y = 2720.28, z = 41.88, h = 5.40},
            {x = 568.78, y = 2720.25, z = 41.88, h = 5.15},
            {x = 565.86, y = 2719.79, z = 41.88, h = 3.42},
            {x = 562.68, y = 2719.95, z = 41.88, h = 3.98},
            {x = 559.54, y = 2719.52, z = 41.88, h = 3.45},
        }
    },
    {
        label = 'Paleto Bay Garage',
        type = 'car',
        pedCoords = {x = 140.62, y = 6613.02, z = 31.06, h = 183.37},
        zone = {name = 'paleto', x = 152.63, y = 6600.21, z = 30.84, l = 28.2, w = 27.2, h = 0, minZ = 30.84, maxZ = 34.84},
        spawns = {
            {x = 145.55, y = 6601.92, z = 31.67, h = 357.80},
            {x = 150.56, y = 6597.71, z = 31.67, h = 359.00},
            {x = 155.55, y = 6592.92, z = 31.67, h = 359.57},
            {x = 145.90, y = 6613.97, z = 31.64, h = 0.60},
            {x = 151.04, y = 6609.26, z = 31.69, h = 357.50},
            {x = 155.84, y = 6602.45, z = 31.86, h = 0.47},
        }
    },
    {
        label = 'Highway Pier Garage',
        type = 'boat',
        pedCoords = {x = -3428.27, y = 967.34, z = 7.35, h = 269.47},
        zone = {name = 'pier', x = -3426.48, y =  968.89, z = 8.35, l = 31.2, w = 39.2, h = 0, minZ = nil, maxZ = nil},
        spawns = {
            {x = -3444.37, y = 952.64, z = 1.02, h = 98.70},
            {x = -3441.02, y = 965.30, z = 0.17, h = 87.18},
        }
    },
    {
        label = 'LSIA Garage',
        type = 'aircraft',
        pedCoords = {x = -941.43, y = -2954.87, z = 12.95, h = 151.00},
        zone = {name = 'lsia', x = -968.31, y = -2992.47, z = 13.95, l = 94.4, w = 84.6, h = 330, minZ = nil, maxZ = nil},
        spawns = {
            {x = -958.57, y = -2987.20, z = 13.95, h = 58.19},
            {x = -971.89, y = -3008.83, z = 13.95, h = 59.47},
            {x = -984.30, y = -3025.04, z = 13.95, h = 58.52},
        }
    },
    --[[ 
        TEMPLATE:
        {
            label = '', -- name that will be displayed in menus
            type = 'car', -- can be 'car', 'boat' or 'aircraft',
            job = 'jobName', -- Set garage to be only accessed and stored into by a job (Optional)
            ped = `ped_model_name`, -- Define the model model you want to use for the garage (Optional)
            pedCoords = {x = X, y = X, z = X, h = X}, -- Ped MUST be inside the create zone
            zone = {name = 'somename', x = X, y = X, z = X, l = X, w = X, h = X, minZ = X, maxZ = x}, -- l is length of the box zone, w is width, h is heading, take all walues from generated zone from /pzcreate
            spawns = { -- You can have as many as you'd like
                {x = X, y = X, z = X, h = X},
                {x = X, y = X, z = X, h = X}
            }
        },
    ]]
}
  
-- BoxZone:Create(vector3(228.68, -789.15, 30.59), 52.4, 43.6, {
--     name="legion",
--     heading=340,
--     --debugPoly=true,
--     minZ=28.99,
--     maxZ=32.99
--   })
