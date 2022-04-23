ESX = nil
TriggerEvent(Config.ESX.SharedObjectTrigger, function(obj) ESX = obj end)

function SendWebhook(url, username, color, title, message, footer)
    local content = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer,
            }
        }
    }
    PerformHttpRequest(
        url,
        function(err, text, headers)
        end,
        'POST',
        json.encode(
            {
                username = username,
                embeds = content
            }
        ),
        {
            ['Content-Type'] = 'application/json'
        }
    )
end

function GetCharacterName(identifier)
    local result = MySQL.Sync.fetchAll(
        'SELECT firstname, lastname FROM users WHERE identifier = @identifier',
        {
            ['identifier'] = identifier
        }
    )
    return result[1].firstname .. ' ' .. result[1].lastname
end

function RegisterTicket(source, ticketType)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute(
        "INSERT INTO lottery (identifier, type, run, win) VALUES (@identifier, @type, 0, 0)",
        {
            ['identifier'] = xPlayer.getIdentifier(),
            ['type'] = ticketType
        },
        function(changed)
            Info('Registered new lottery ticket ' .. ticketType .. '. (' .. xPlayer.getName() .. ';' .. xPlayer.getIdentifier() .. ')')
            SendWebhook(
                Webhooks.Bought.URL,
                Webhooks.Bought.Username,
                Webhooks.Bought.Color,
                Webhooks.Bought.Title,
                (Webhooks.Bought.Description)
                :format(
                    GetCharacterName(xPlayer.getIdentifier()),
                    ticketType
                ),
                (Webhooks.Bought.Footer)
                :format(
                    xPlayer.getName(),
                    xPlayer.getIdentifier()
                )
            )
        end
    )
end

RegisterServerEvent('codely_lottery:buyTicket')
AddEventHandler('codely_lottery:buyTicket', function(ticketType)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.LotteryShop.Tickets[ticketType]
    local itemName = 'ticket_' .. ticketType
    if xPlayer.getMoney() >= price then
        if Config.ESX.Version == 1.1 then
            xPlayer.removeMoney(price)
            xPlayer.addInventoryItem(itemName, 1)
            SendServerNotification(
                source,
                'success',
                (Config.LotteryShop.Messages.Bought)
                :format(
                    ticketType,
                    price
                )
            )
            RegisterTicket(source, ticketType)
        elseif Config.ESX.Version == 1.2 then
            if xPlayer.canCarryItem(itemName, 1) then
                xPlayer.removeMoney(price)
                xPlayer.addInventoryItem(itemName, 1)
                SendServerNotification(
                    source,
                    'success',
                    (Config.LotteryShop.Messages.Bought)
                    :format(
                        ticketType,
                        price
                    )
                )
                RegisterTicket(source, ticketType)
            else
                SendServerNotification(
                    source,
                    'error',
                    Config.LotteryShop.Messages.CantCarryMoreItems
                )
            end
        else
            SendServerNotification(
                source,
                'error',
                'The wrong version of ESX is in the configuration files.'
            )
        end
    else
        SendServerNotification(
            source,
            'error',
            Config.LotteryShop.Messages.EnoughMoney
        )
    end
end)

function IsPlayerHasWin(identifier, ticketType)
    local result = MySQL.Sync.fetchAll(
        'SELECT * FROM lottery_wins WHERE identifier = @identifier AND type = @type',
        {
            ['identifier'] = identifier,
            ['type'] = ticketType
        }
    )
    if result[1] == nil then
        return false
    else
        return true
    end
end

function IsPlayerClaimedWin(identifier, ticketType)
    local result = MySQL.Sync.fetchAll(
        'SELECT * FROM lottery_wins WHERE identifier = @identifier AND type = @type AND claimed = 0',
        {
            ['identifier'] = identifier,
            ['type'] = ticketType
        }
    )
    if result[1] == nil then
        return true
    else
        return false
    end
end

function ClaimWin(source, identifier, ticketType)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchAll(
        'SELECT * FROM lottery_wins WHERE identifier = @identifier AND type = @type AND claimed = 0',
        {
            ['identifier'] = identifier,
            ['type'] = ticketType
        }
    )
    local id = result[1].id
    MySQL.Async.execute(
        "UPDATE lottery_wins SET claimed = 1 WHERE id = @id",
        {
            ['id'] = id
        }
    )
    xPlayer.addMoney(result[1].price)
    SendServerNotification(
        source,
        'info',
        (Config.LotteryShop.Messages.PayOff)
        :format(
            result[1].price,
            ticketType
        )
    )
end

RegisterServerEvent('codely_lottery:payOff')
AddEventHandler('codely_lottery:payOff', function(ticketType)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    --local itemName = 'ticket_' .. ticketType
    --if xPlayer.getInventoryItem(itemName).count > 0 then
    if IsPlayerHasWin(xPlayer.getIdentifier(), ticketType) then
        if not IsPlayerClaimedWin(xPlayer.getIdentifier(), ticketType) then
            ClaimWin(
                _source,
                xPlayer.getIdentifier(),
                ticketType
            )
        else
            SendServerNotification(
                _source,
                'error',
                Config.LotteryShop.Messages.NotWin
            )
        end
    else
        SendServerNotification(
            _source,
            'error',
            Config.LotteryShop.Messages.NotWin
        )
    end
    --else
    --    SendServerNotification(_source, 'error', Config.LotteryShop.Messages.NotItem)
    --end
end)

if Config.Debug.StartCommand.Enabled then
    RegisterCommand('startlottery', function()
        Info('Starting lottery debug.')
        StartLottery(Config.Debug.StartCommand.TicketType)
    end)
end

function RegisterWin(identifier, ticketType, price)
    MySQL.Async.execute(
        "INSERT INTO lottery_wins (identifier, type, price, claimed) VALUES (@identifier, @type, @price, 0)",
        {
            ['identifier'] = identifier,
            ['type'] = ticketType,
            ['price'] = price
        }
    )
end

function StartLottery(ticketType)
    local tickets = MySQL.Sync.fetchAll(
        'SELECT * FROM lottery WHERE run = 0 AND type = @type',
        {
            ['type'] = ticketType
        }
    )
    if #tickets == 0 then
        Warn('Lottery win was cancelled. Nobody bought tickets.')
        return
    end
    local price = 0
    for i = 1, #tickets, 1 do
        price = price + Config.LotteryShop.Tickets[tickets[i].type]
    end
    local winRow = tickets[math.random(#tickets)]
    SendWebhook(
        Webhooks.Run.URL,
        Webhooks.Run.Username,
        Webhooks.Run.Color,
        Webhooks.Run.Title,
        (Webhooks.Run.Description)
        :format(
            GetCharacterName(winRow.identifier),
            price,
            ticketType
        ),
        Webhooks.Run.Footer
    )
    MySQL.Async.execute(
        "UPDATE lottery SET run = 1 WHERE type = @type",
        {
            ['type'] = ticketType
        }
    )
    MySQL.Async.execute(
        "UPDATE lottery SET win = 1 WHERE id = @id",
        {
            ['id'] = winRow.id
        }
    )
    RegisterWin(
        winRow.identifier,
        ticketType,
        price
    )
    SendAnnouncement(
        GetCharacterName(winRow.identifier),
        price,
        ticketType
    )
end

function CronTask(d, h, m)
    if Config.LotteryStart.DayInWeek.Enabled then
        if d == Config.LotteryStart.DayInWeek.Day then
            for key, value in pairs(Config.LotteryShop.Tickets) do
                StartLottery(key)
                Citizen.Wait(1000)
            end
        end
    else
        for key, value in pairs(Config.LotteryShop.Tickets) do
            StartLottery(key)
            Citizen.Wait(1000)
        end
    end

end

TriggerEvent('cron:runAt', Config.LotteryStart.Start.Hour, Config.LotteryStart.Start.Minutes, CronTask)
