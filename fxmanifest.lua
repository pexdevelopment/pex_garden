fx_version 'adamant'

game 'gta5'

description 'PEX Garden'

version '1.1'

lua54 'yes'

shared_scripts {'@es_extended/imports.lua', '@ox_lib/init.lua'}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'client/main.lua',
	'config.lua',
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'server/main.lua',
	'config.lua',
}
