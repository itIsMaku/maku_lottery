local framework = require 'modules.framework.resolve'
local blip = require 'modules.commons.blip'
local log = require 'modules.commons.log'
local menus = require 'modules.menus.client'

local inside = false

for index, coords in ipairs(Config.Locations) do
    Config.Blip.coords = coords
    blip.createNewBlip(Config.Blip)
    TriggerEvent('polyZone:createZone', 'lottery_' .. index, 'box', {
        coords = coords,
        width = 2.0,
        height = 2.0,
        heading = 0,
        minZ = coords.z - 1.0,
        maxZ = coords.z + 1.0
    })
end

AddEventHandler('polyZone:enteredZone', function(name, point)
    if name:find('lottery_') then
        log.debug('Entered lottery zone ' .. name)
        inside = true
        Citizen.CreateThread(function()
            while inside do
                framework.showHelpNotification(Config.Translations.HelpText)
                if IsControlJustReleased(0, 38) then
                    menus.openLotteryShop()
                end
                Citizen.Wait(0)
            end
        end)
    end
end)

AddEventHandler('polyZone:leftZone', function(name, point)
    if name:find('lottery_') then
        log.debug('Left lottery zone ' .. name)
        inside = false
    end
end)
