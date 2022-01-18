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
        pedCoords = vector4(409.25, -1623.08, 28.29, 228.84),
        zone = {name = 'innocence', x = 408.02, y = -1637.08, z = 29.29, l = 31.6, w = 26.8, h = 320, minZ = 28.29, maxZ = 32.29}, -- The zone is only here for the ped to not have the impound option everywhere in the world
        blip = {
            scale = 0.8,
            sprite = 285,
            colour = 3
        },
        spawns = {
            vector4(416.83, -1628.29, 29.11, 140.43),
            vector4(419.58, -1629.71, 29.11, 141.98),
            vector4(421.17, -1636.00, 29.11, 88.21),
            vector4(420.05, -1638.93, 29.11, 88.95),
        }
    },
    {
        type = 'boat',
        pedCoords = vector4(-462.92, -2443.44, 5.00, 322.40),
        zone = {name = 'lsboat impound', x = -451.72, y = -2440.42, z = 6.0, l = 22.6, w = 29.4, h = 325, minZ = 5.0, maxZ = 9.0},
        spawns = {
            vector4(-493.48, -2466.38, -0.06, 142.26),
            vector4(-471.09, -2483.94, 0.28, 152.74),
        }
    },
    {
        type = 'aircraft',
        pedCoords = vector4(1758.29, 3297.50, 40.15, 148.27),
        zone = {name = 'sandy air', x = 1757.71, y = 3296.72, z = 41.15, l = 14.4, w = 18.0, h = 50, minZ = 40.13, maxZ = 44.13},
        spawns = {
            vector4(1753.72, 3272.12, 41.99, 105.71),
            vector4(1746.85, 3252.57, 42.30, 105.58),
        }
    },
    --[[
        TEMPLATE:
        {
            label = "", -- Display label for the impound (Optional)
            type = 'car', -- can be 'car', 'boat' or 'aircraft',
            ped = `ped_model_name` -- Define the model model you want to use for the impound (Optional)
            pedCoords = vector4(x, y, z, h), -- Ped MUST be inside the create zone
            zone = {name = 'somename', x = X, y = X, z = X, l = X, w = X, h = X, minZ = X, maxZ = x}, -- l is length of the box zone, w is width, h is heading, take all walues from generated zone from /pzcreate
            blip = { -- Define specific blip setting for this impound (Optional)
                scale = 0.8,
                sprite = 285,
                colour = 3
            },
            spawns = { -- You can have as many as you'd like
                vector4(x, y, z, h),
                vector4(x, y, z, h)
            }
        },
    ]]
}

Config.Garages = {
    {
        label = 'Legion Garage',
        type = 'car', -- car, boat or aircraft
        pedCoords = vector4(215.90, -808.87, 29.74, 248.0), -- The Ped MUST be inside the PolyZone
        zone = {name = 'legion', x = 228.68, y = -789.15, z = 30.59, l = 52.4, w = 39.6, h = 340, minZ = 28.99, maxZ = 32.99},
        spawns = {
            vector4(206.25, -801.21, 31.00, 250.47),
            vector4(206.25, -801.21, 31.00, 250.47),
            vector4(208.72, -796.45, 30.95, 246.74),
            vector4(210.89, -791.42, 30.90, 248.02),
            vector4(216.12, -801.68, 30.80, 68.72),
            vector4(218.21, -796.79, 30.77, 68.80),
            vector4(219.76, -791.47, 30.76, 69.89),
            vector4(221.37, -786.53, 30.78, 70.72),
            vector4(212.52, -783.46, 30.89, 248.63),
        }
    },
    {
        label = 'Americano Way Garage',
        type = 'car',
        pedCoords = vector4(-1651.83, 63.90, 61.86, 338.03),
        zone = {name = 'americano', x = -1682.74, y = 60.93, z = 63.5, l = 59.6, w = 60.6, h = 329, minZ = 61.15, maxZ = 68.35},
        spawns = {
            vector4(-1660.57, 75.52, 63.20, 170.90),
            vector4(-1666.24, 79.84, 63.45, 171.92),
            vector4(-1671.97, 84.59, 63.83, 169.94),
            vector4(-1662.57, 57.99, 62.90, 293.91),
            vector4(-1664.75, 60.63, 63.05, 292.60),
            vector4(-1667.53, 62.90, 63.21, 291.82),
        }
    },
    {
        label = 'Route 68 Garage',
        type = 'car',
        pedCoords = vector4(587.23, 2723.50, 41.13, 7.85),
        zone = {name = 'route68', x = 573.19, y = 2727.17, z = 42.06, l = 22.4, w = 51.2, h = 4, minZ = 41.08, maxZ = 45.08},
        spawns = {
            vector4(584.51, 2721.56, 41.88, 3.59),
            vector4(581.14, 2721.32, 41.88, 3.99),
            vector4(578.15, 2720.59, 41.88, 4.65),
            vector4(574.86, 2721.09, 41.88, 4.85),
            vector4(572.01, 2720.28, 41.88, 5.40),
            vector4(568.78, 2720.25, 41.88, 5.15),
            vector4(565.86, 2719.79, 41.88, 3.42),
            vector4(562.68, 2719.95, 41.88, 3.98),
            vector4(559.54, 2719.52, 41.88, 3.45),
        }
    },
    {
        label = 'Paleto Bay Garage',
        type = 'car',
        pedCoords = vector4(140.62, 6613.02, 31.06, 183.37),
        zone = {name = 'paleto', x = 152.63, y = 6600.21, z = 30.84, l = 28.2, w = 27.2, h = 0, minZ = 30.84, maxZ = 34.84},
        spawns = {
            vector4(145.55, 6601.92, 31.67, 357.80),
            vector4(150.56, 6597.71, 31.67, 359.00),
            vector4(155.55, 6592.92, 31.67, 359.57),
            vector4(145.90, 6613.97, 31.64, 0.60),
            vector4(151.04, 6609.26, 31.69, 357.50),
            vector4(155.84, 6602.45, 31.86, 0.47),
        }
    },
    {
        label = 'Highway Pier Garage',
        type = 'boat',
        pedCoords = vector4(-3428.27, 967.34, 7.35, 269.47),
        zone = {name = 'pier', x = -3426.48, y =  968.89, z = 8.35, l = 31.2, w = 39.2, h = 0, minZ = nil, maxZ = nil},
        spawns = {
            vector4(-3444.37, 952.64, 1.02, 98.70),
            vector4(-3441.02, 965.30, 0.17, 87.18),
        }
    },
    {
        label = 'LSIA Garage',
        type = 'aircraft',
        pedCoords = vector4(-941.43, -2954.87, 12.95, 151.00),
        zone = {name = 'lsia', x = -968.31, y = -2992.47, z = 13.95, l = 94.4, w = 84.6, h = 330, minZ = nil, maxZ = nil},
        spawns = {
            vector4(-958.57, 2987.20, 13.95, 58.19),
            vector4(-971.89, 3008.83, 13.95, 59.47),
            vector4(-984.30, 3025.04, 13.95, 58.52),
        }
    },
    {
        label = 'MRPD Police Garage',
        type = 'car',
        job = 'police',
        ped = `s_m_y_cop_01`,
        pedCoords = vector4(450.6633, -1027.3324, 27.5732, 5.1321),
        zone = {name = 'mrpd', x = 439.36, y= -1021.04, z = 28.83, l = 20, w = 40, h = 0, minZ = 27.03, maxZ = 31.03},
        spawns = {
            vector4(446.4181, -1026.2117, 28.2490, 357.9764),
            vector4(442.5637, -1025.5530, 28.2984, 1.7611),
            vector4(438.6664, -1027.0088, 28.3936, 3.1104),
            vector4(434.8707, -1026.6675, 28.4554, 3.9030),
            vector4(431.6170, -1026.7904, 28.5088, 0.9789),
            vector4(427.3045, -1027.6506, 28.5950, 5.8251)
        }
    },
    {
        label = 'Pillbox Ambulance Garage',
        type = 'car',
        job = 'ambulance',
        ped = `s_m_m_doctor_01`,
        pedCoords = vector4(319.3737, -559.4569, 27.7438, 21.0252),
        zone = {name = 'pillbox', x = 325.59, y = -549.27, z = 28.74, l = 25, w = 25, h = 0, minZ = 27.74, maxZ = 30.74},
        spawns = {
            vector4(321.0445, 542.4713, 28.5142, 180.9354),
            vector4(323.8813, 542.8687, 28.5135, 181.6986),
            vector4(326.6019, 542.6691, 28.5133, 179.8377),
            vector4(329.3755, 542.5102, 28.5137, 179.7974),
            vector4(332.2085, 542.5237, 28.5125, 181.5656)
        }
    },
    --[[
        TEMPLATE:
        {
            label = '', -- name that will be displayed in menus
            type = 'car', -- can be 'car', 'boat' or 'aircraft',
            job = 'jobName', -- Set garage to be only accessed and stored into by a job (Optional)
            ped = `ped_model_name`, -- Define the model model you want to use for the garage (Optional)
            pedCoords = vector4(x, y, z, h), -- Ped MUST be inside the create zone
            zone = {name = 'somename', x = X, y = X, z = X, l = X, w = X, h = X, minZ = X, maxZ = x}, -- l is length of the box zone, w is width, h is heading, take all walues from generated zone from /pzcreate
            blip = { -- Define specific blip setting for this garage (Optional)
                scale = 0.8,
                sprite = 357,
                colour = 3
            },
            spawns = { -- You can have as many as you'd like
                vector4(x, y, z, h),
                vector4(x, y, z, h)
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
