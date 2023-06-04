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
	'client/functions.lua',
	'client/electrician.lua',
	'client/factory_helper.lua',
	'client/cleaner.lua',
	'client/police_intern.lua',
	'client/commands.lua',
	'client/used_car_lot.lua'
}