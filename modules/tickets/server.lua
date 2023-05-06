local framework = require 'modules.framework.resolve'
local log = require 'modules.commons.log'
local tables = require 'modules.commons.tables'
local discord = require 'modules.commons.discord'

function registerTicket(playerId, category)
    local identifier = framework.getIdentifier(playerId)
    local name = GetPlayerName(playerId)
    MySQL.Async.execute(
        "INSERT INTO lottery (identifier, category) VALUES (@identifier, @category)",
        {
            ['@identifier'] = identifier,
            ['@category'] = category
        },
        function(changed)
            log.debug('Registered new lottery ticket %s (%s, %s)', category, identifier, name)
            discord.sendWebhook(Webhooks.bought, {
                ['{name}'] = name,
                ['{identifier}'] = identifier,
                ['{category}'] = category,
                ['{character}'] = framework.getCharacterName(identifier)
            })
        end
    )
end

function getPlayerWin(identifier, category)
    local rows = MySQL.Sync.fetchAll(
        'SELECT * FROM lottery WHERE identifier = @identifier AND category = @category AND win = 1', {
            ['@identifier'] = identifier,
            ['@category'] = category
        })
    if #rows > 0 then
        return rows[1]
    end
    return nil
end

function claimWin(playerId, category)
    local identifier = framework.getIdentifier(playerId)
    local row = MySQL.Sync.fetchAll(
        'SELECT * FROM lottery_wins WHERE identifier = @identifier AND category = @category AND claimed = 0',
        {
            ['@identifier'] = identifier,
            ['@category'] = category
        })
    if #row == 0 then
        framework.sendNotification(playerId, 'error', Config.Translations.Notifications.NotWin)
        return
    end
    MySQL.Async.execute('UPDATE lottery_wins SET claimed = 1 WHERE id = @id', {
        ['@id'] = row[1].id
    })
    framework.addMoney(playerId, 'money', row[1].price)
    framework.sendNotification(playerId, 'success',
        Config.Translations.Notifications.PayOff:format(row[1].price,
            tables.retreive_inner(Config.Categories, 'id', category).name))
end

function startLottery(category)
    local tickets = MySQL.Sync.fetchAll(
        'SELECT * FROM lottery WHERE run = 0 AND category = @category',
        {
            ['@category'] = category
        }
    )
    if #tickets == 0 then
        log.warn('Lottery draw was cancelled. There are no tickets in pool.')
        return
    end
    local categoryElement = tables.retreive_inner(Config.Categories, 'id', category)
    local price = 0
    for i = 1, #tickets, 1 do
        price = price + categoryElement.price
    end
    local win = tickets[math.random(#tickets)]
    local characterName = framework.getCharacterName(win.identifier)
    discord.sendWebhook(Webhooks.draw, {
        ['{identifier}'] = win.identifier,
        ['{category}'] = categoryElement.name,
        ['{character}'] = characterName,
        ['{price}'] = price
    })
    MySQL.Async.execute(
        "UPDATE lottery SET run = 1 WHERE category = @category",
        {
            ['@category'] = category
        }
    )
    MySQL.Async.execute(
        "UPDATE lottery SET win = 1 WHERE id = @id",
        {
            ['@id'] = win.id
        }
    )
    MySQL.Async.execute(
        "INSERT INTO lottery_wins (identifier, category, price, claimed) VALUES (@identifier, @category, @price, 0)",
        {
            ['identifier'] = win.identifier,
            ['category'] = category,
            ['price'] = price
        }
    )
    TriggerClientEvent('chat:addMessage', -1, {
        template =
        '<div style="padding: 0.45vw; margin: 0.05vw; background-color: rgba(255, 153, 51, 0.5); border-radius: 6px;"><i class="fas fa-ticket-alt"></i> | <b>Lottery</b><p>{0} won ${1} in the category {2}.</p></div>',
        args = { characterName, price, category }
    })
end

return {
    registerTicket = registerTicket,
    getPlayerWin = getPlayerWin,
    claimWin = claimWin,
    startLottery = startLottery
}
