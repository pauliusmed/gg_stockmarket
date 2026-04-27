fx_version 'adamant'
game 'rdr3'

author 'GrybasTv'
description 'RedM Stock Market System using VORP Core'
version '1.4.1'

lua54 'yes'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'


shared_script {    
    'config.lua', -- Konfigūracijos failas    
}

-- Serverio skriptai
server_scripts {
    '@mysql-async/lib/MySQL.lua', -- Užtikrina MySQL ryšį   
    'server/server.lua', -- Serverio logika
}

-- Kliento skriptai
client_scripts {   
    'client/client.lua', -- Kliento logika
}


escrow_ignore {
    'config.lua',
    'server/server.lua',
    'client/client.lua',
}


-- Priklausomybės
dependencies {
    'vorp_core', -- Reikalingas VORP Core framework
    'vorp_inventory', -- Reikalingas VORP Inventory sistema
    'vorp_menu'-- Reikalingas VORP Menu sistema
}
