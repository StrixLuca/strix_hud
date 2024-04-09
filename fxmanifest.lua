fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'rsg-hud'
version '1.2.3'

shared_scripts {
    '@ox_lib/init.lua',
    '@rsg-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
    '@oxmysql/lib/MySQL.lua',
}

dependencies {
    'rsg-core',
    'ox_lib',
    'rsg-telegram',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/app.js'
}

lua54 'yes'
