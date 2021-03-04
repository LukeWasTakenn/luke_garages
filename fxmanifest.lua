fx_version 'cerulean'

game 'gta5'

author 'Luke'
description 'Vehicle garages and impounds for the ESX framework'
version '1.0.0'

client_scripts{
    "@warmenu/warmenu.lua",
    'client/client.lua',
    'config.lua',
}

server_scripts{
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua',
    'config.lua',
}