Config = {}

Config.MarkerDrawDistance = 20.0

--Config.StoreVehiclesOnResourceStart - Check server.lua for this

Config.SaveDamageOnStore = true -- Whether or not you want the damage on the vehicle to stay when you store it into a garage (Fuel will always save)
Config.ImpoundPrice = 750 -- Price to get the impounded vehicle out
Config.UseCash = true


Config.Impounds = {
    InnocenceImpound = {
        impoundName = 'Innocence Blv Impound',
        impoundType = 'car', -- aircraft, boat or car
        menuCoords = {x = 402.39, y = -1628.04, z = 29.29},
        spawnCoords = {
            {x = 416.07, y = -1629.16, z = 29.29, h = 319.06},
            {x = 406.98, y = -1651.0, z = 29.29, h = 141.1},
            {x = 397.89, y = -1642.67, z = 29.29, h = 146.7},
        },
    },

    SandyImpound = {
        impoundName = 'Sandy Shores Impound',
        impoundType = 'car', -- aircraft, boat or car
        menuCoords = {x = 917.99, y = 3577.14, z = 33.55},
        spawnCoords = {
            {x = 920.22, y = 3568.7, z = 33.64, h = 275.12},
            {x = 920.12, y = 3561.3, z = 33.75, h = 271.76},
        },
    },

    PaletoImpound = {
        impoundName = 'Paleto Bay Impound',
        impoundType = 'car', -- aircraft, boat or car
        menuCoords = {x = 120.01, y = 6625.96, z = 31.96},
        spawnCoords = {
            {x = 139.99, y = 6638.14, z = 31.6, h = 136.0},
            {x = 129.55, y = 6628.82, z = 31.31, h = 133.69},
        },
    },

    SLSImpound = {
        impoundName = 'South Los Santos Impound',
        impoundType = 'boat', -- aircraft, boat or car
        menuCoords = {x = 45.91, y = -2791.97, z = 5.72},
        spawnCoords = {
            {x = 55.52, y = -2791.26, z = 5.72, h = 174.32},
            {x = 35.03, y = -2791.48, z = 5.32, h = 179.32},
        },
    },

    LSAPImpound = {
        impoundName = 'LSAP Impound',
        impoundType = 'aircraft', -- aircraft, boat or car
        menuCoords = {x = -1071.41, y = -2869.27, z = 13.95},
        spawnCoords = {
            {x = -1084.61, y = -2901.37, z = 13.95, h = 243.28},
        },
    },
    --[[ TEMPLATE ----
    ImpoundName = {
        impoundName = '',
        impoundType = '', -- aircraft, boat or car
        menuCoords = {x = , y = , z = },
        spawnCoords = {
            {x = , y = , z = , h = },
        },
    },
    ]]
}

Config.Garages = {
    LegionGarage = {
        garageName = 'Legion Garage',
        garageType = 'car',
        menuCoords = {x = 216.8, y = -810.8, z = 30.7},
        spawnCoords = {
            {x = 223.03, y = -801.57, z = 30.66, h = 68.92},
            {x = 209.05, y = -796.54, z = 30.95, h = 67.96},
            {x = 220.67, y = -786.34, z = 30.78, h = 249.37},
        },
        returnCoords = {x = 234.68, y = -787.05, z = 30.61},
    },

    ElRanchoGarage = {
        garageName = 'El Rancho Garage',
        garageType = 'car',
        menuCoords = {x = 1204.65, y = -1084.42, z = 40.48},
        spawnCoords = {
            {x = 1199.92, y = -1059.37, z = 41.14, h = 301.52},
            {x = 1204.44, y = -1062.48, z = 40.64, h = 299.62},
            {x = 1208.21, y = -1065.76, z = 40.21, h = 298.76},
            {x = 1211.22, y = -1069.71, z = 39.90, h = 303.09},
            {x = 1215.04, y = -1073.32, z = 39.51, h = 305.75},
        },
        returnCoords = {x = 1195.72, y = -1056.44, z = 41.55},
    },

    VespucciGarage = {
        garageName = 'Vespucci Blvd Garage',
        garageType = 'car',
        menuCoords = {x = -332.66, y = -781.49, z = 33.96},
        spawnCoords = {
            {x = -334.57, y = -751.31, z = 33.97, h = 179.12},
            {x = -343.02, y = -756.97, z = 33.97, h = 270.03},
            {x = -329.05, y = -750.43, z = 33.97, h = 181.60},
            {x = -323.11, y = -751.78, z = 33.97, h = 156.22},
            {x = -317.46, y = -752.89, z = 33.97, h = 160.17},
        },
        returnCoords = {x = -348.57, y = -761.12, z = 33.97},
    },

    SpanishAveGarage = {
        garageName = 'Spanish Avenue Garage',
        garageType = 'car',
        menuCoords = {x = 76.67, y = 20.34, z = 69.13},
        spawnCoords = {
            {x = 64.70, y = 17.97, z = 69.29, h = 158.63},
            {x = 61.25, y = 19.31, z = 69.37, h = 158.63},
            {x = 58.22, y = 20.33, z = 69.46, h = 161.80},
            {x = 55.25, y = 21.32, z = 69.69, h = 164.56},
        },
        returnCoords = {x = 57.09, y = 28.96, z = 70.06},
    },

    SandyGarage = {
        garageName = 'Sandy Shores Garage',
        garageType = 'car',
        menuCoords = {x = 1527.31, y = 3771.82, z = 34.51},
        spawnCoords = {
            {x = 1512.15, y = 3759.74, z = 34.00, h = 17.32},
            {x = 1498.60, y = 3758.94, z = 33.92, h = 33.92},
            {x = 1495.40, y = 3757.72, z = 33.90, h = 31.92},
        },
        returnCoords = {x = 1504.87, y = 3763.27, z = 34.0},
    },

    PaletoGarage = {
        garageName = 'Paleto Bay Garage',
        garageType = 'car',
        menuCoords = {x = 109.08, y = 6606.11, z = 31.85},
        spawnCoords = {
            {x = 145.55, y = 6600.84, z = 31.85, h = 1.79},
            {x = 140.58, y = 6605.59, z = 31.84, h = 359.21},
            {x = 146.03, y = 6613.43, z = 31.82, h = 180.47},
            {x = 150.98, y = 6609.00, z = 31.87, h = 181.67},
            {x = 150.97, y = 6596.92, z = 31.84, h = 0.24},
        },
        returnCoords = {x = 123.98, y = 6611.3, z = 31.85},
    },

    PierBoatGarage = {
        garageName = 'Pier Boat Garage',
        garageType = 'boat',
        menuCoords = {x = -829.92, y = -1411.64, z = 1.61},
        spawnCoords = {
            {x = -830.31, y = -1417.52, z = 0.8, h = 106.09},
        },
        returnCoords = {x = -842.0, y = -1411.02, z = 0.8},
    },

    AircraftGarage = {
        garageName = 'LSAP Garage',
        garageType = 'aircraft',
        menuCoords = {x = -1101.89, y = -2988.86, z = 13.96},
        spawnCoords = {
            {x = -1091.9, y = -3006.18, z = 13.94, h = 218.08},
        },
        returnCoords = {x = -1130.73, y = -2988.73, z = 13.94},
    },
    --[[ TEMPLATE ----
    GarageName = {
        garageName = '',
        garageType = '', -- aircraft, boat or car
        menuCoords = {x = , y = , z = },
        spawnCoords = {
            {x = , y = , z = , h = },
        },
        returnCoords = {x = , y = , z = },
    },
    ]]
}