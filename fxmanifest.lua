game "gta5"
fx_version 'cerulean'
lua54 'yes'
version '1.2'

client_scripts {
	'client/cl_utils.lua',
	'client/cl_main.lua'
}

shared_scripts {
	'configs/sh_config.lua'
}

server_scripts {
	'configs/sv_config.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/database/*.lua',

	'server/sv_utils.lua',
	'server/sv_dbloader.lua',
	'server/sv_main.lua'
}

depencies {
	'es_extended',
	'cron'
}

escrow_ignore {
	'server/database/*.lua',
	'client/cl_utils.lua',
	'configs/*.lua'
}

dependency '/server:4700' -- You must have server artifact at least 4700
