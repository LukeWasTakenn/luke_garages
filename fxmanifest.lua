fx_version 'cerulean'

game 'gta5'

author 'Luke - https://www.github.com/lukewastakenn'

version '2.1.5'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
    'client/vehicle_names.lua',
    'client/client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/version_check.lua',
    'server/server.lua'
}
