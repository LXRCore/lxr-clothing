--[[
    ██╗     ██╗  ██╗██████╗        ██████╗██╗      ██████╗ ████████╗██╗  ██╗██╗███╗   ██╗ ██████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██║     ██╔═══██╗╚══██╔══╝██║  ██║██║████╗  ██║██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║     ██║   ██║   ██║   ███████║██║██╔██╗ ██║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║     ██║   ██║   ██║   ██╔══██║██║██║╚██╗██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗███████╗╚██████╔╝   ██║   ██║  ██║██║██║ ╚████║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝

    🐺 LXR Clothing System
    Advanced Character Customization for RedM / Red Dead Redemption 2 RP

    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════

    Server:    The Land of Wolves 🐺
    Developer: iBoss21 / The Lux Empire
    Website:   https://www.wolves.land
    Discord:   https://discord.gg/CrKcWdfd3A
    Store:     https://theluxempire.tebex.io

    ═══════════════════════════════════════════════════════════════════════════════

    Framework Support:
    - LXR Core  (Primary)
    - RSG Core  (Primary)
    - VORP Core (Supported)

    ═══════════════════════════════════════════════════════════════════════════════
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

fx_version 'cerulean'
game       'rdr3'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name        'lxr-clothing'
author      'iBoss21 / The Lux Empire'
description 'LXR Clothing System — Advanced character customization for The Land of Wolves 🐺'
version     '1.0.1'

ui_page 'html/dist/index.html'

shared_scripts {
	'shared/config.lua',
	'shared/framework.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

client_scripts {
	'client/*.lua',
}

files {
	'html/dist/index.html',
	'html/dist/*.png',
	'html/dist/app.js',
	'html/dist/*.eot',
	'html/dist/*.woff2',
	'html/dist/*.woff',
	'html/dist/*.ttf',
}

lua54 'yes'
