game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

client_scripts {
    'client.lua',
    "cl_anim.lua",
}

server_scripts {
    'server.lua',
    "@oxmysql/lib/MySQL.lua",
}

shared_script {
    'config.lua',
}

files {
    'ui/dist/**/*',
    'ui/assets/*',
    'ui/assets/fonts/*',
}

ui_page 'ui/dist/index.html'


author 'Shamey Winehouse'
description 'License: GPL-3.0-only'