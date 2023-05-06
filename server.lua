local framework = require 'modules.framework.resolve'
local log = require 'modules.commons.log'
local tables = require 'modules.commons.tables'
local tickets = require 'modules.tickets.server'

MySQL.ready(function()
    MySQL.Sync.execute([[
        CREATE TABLE IF NOT EXISTS `lottery` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(40) DEFAULT NULL,
            `category` VARCHAR(40) NOT NULL,
            `run` INT NOT NULL DEFAULT 0,
            `win` INT NOT NULL DEFAULT 0,

            PRIMARY KEY (`id`)
        )
    ]], {})
    MySQL.Sync.execute([[
        CREATE TABLE IF NOT EXISTS `lottery_wins` (
	        `id` INT NOT NULL AUTO_INCREMENT,
	        `identifier` VARCHAR(40) DEFAULT NULL,
	        `category` VARCHAR(40) NOT NULL,
	        `price` INT NOT NULL,
	        `claimed` INT NOT NULL DEFAULT 0,

	        PRIMARY KEY (`id`)
        )
    ]], {})
end)

RegisterNetEvent('maku_lottery:buyTicket', function(category)
    local playerId = source
    local category = tables.retreive_inner(Config.Categories, 'id', category)
    local price = category.price
    if framework.getMoney(playerId, 'money') < price then
        framework.sendNotification(playerId, 'error', Config.Translations.Notifications.EnoughMoney)
        return
    end
    framework.removeMoney(playerId, 'money', price)
    tickets.registerTicket(playerId, category.id)
    framework.sendNotification(playerId, 'success', Config.Translations.Notifications.Bought:format(category.name, price))
end)

RegisterNetEvent('maku_lottery:payOff', function(category)
    local playerId = source
    local win = tickets.getPlayerWin(framework.getIdentifier(playerId), category)
    if tables.size(win) == 0 then
        framework.sendNotification(playerId, 'error', Config.Translations.Notifications.NotWin)
        return
    end
    tickets.claimWin(playerId, category)
end)

RegisterCommand('startlottery', function()
    log.debug('Starting lottery debug.')
    tickets.startLottery('bronze')
end)

TriggerEvent('cron:runAt', Config.Draw.Hour, Config.Draw.Minutes, function(day, hour, minutes)
    local execute = false
    if Config.Draw.Day == nil then
        execute = true
    elseif Config.Draw.Day == day then
        execute = true
    end
    if execute then
        for index, category in ipairs(Config.Categories) do
            tickets.startLottery(category)
            Citizen.Wait(1000)
        end
    end
end)
