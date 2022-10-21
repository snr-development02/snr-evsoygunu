fx_version 'cerulean'
game 'gta5'

description 'QB-HouseRobbery'
version '1.0.0'

shared_scripts {
 'config.lua',
 '@qb-core/shared/locale.lua'

}
client_script 'client/main.lua'
server_script 'server/main.lua'

dependencies {
 'qb-lockpick'
}

lua54 'yes'
