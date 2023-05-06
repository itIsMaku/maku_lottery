fx_version 'cerulean'
game 'gta5'
version '1.4'
author 'maku#5434'
description 'lottery script for FiveM'

lua54 'yes'

shared_scripts {
	'config.lua',
	'internal/require.lua',

	'modules/commons/blip.lua',
	'modules/commons/log.lua',
	'modules/commons/tables.lua'
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',

	'modules/framework/type/esx/client.lua',
	'modules/framework/type/qb/client.lua',
	'modules/framework/resolve.lua',
	'modules/menus/client.lua',

	'internal/polyzone.lua',
	'client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',

	'data/webhooks.lua',

	'modules/commons/discord.lua',
	'modules/framework/type/esx/server.lua',
	'modules/framework/type/qb/server.lua',
	'modules/framework/resolve.lua',
	'modules/tickets/server.lua',

	'internal/cron.lua',

	'server.lua'
}

depencies {
	'PolyZone'
}
