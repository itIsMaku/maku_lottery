game "gta5"
fx_version 'cerulean'
lua54 'yes'
version '1.2'

client_scripts {
	'client/*.lua',
	'configs/cl_config.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/database/*.lua'

	'server/*.lua',
	'configs/sv_config.lua'
}

depencies {
	'es_extended',
	'cron'
}

escrow_ignore {
	'server/database/*.lua',
	'client/cl_utils.lua',
	'configs/*.lua',
}

dependency '/server:4700' -- You must have server artifact at least 4700
