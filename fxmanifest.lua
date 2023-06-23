fx_version 'adamant'

game 'gta5'

description 'PaletoLives'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/main.lua',
	'server/commands.lua',
	'server/used_car_lot.lua'
}

client_scripts {
	'config.lua',
	'client/helpers/*.lua',
	'client/jobs/*.lua',
	'client/misc/*.lua',
}