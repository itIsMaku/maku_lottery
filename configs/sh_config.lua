Config = {}

Config.ESX = {
    SharedObjectTrigger = 'esx:getSharedObject',
    --[[
        Versions:
            1.1 - Without weight system, everything what's below and including this version
            1.2 - With weight system, everything what's above and including this version
    ]]
    Version = 1.1
}

Config.LotteryShop = {
    Location = vector3(-47.21, -1755.72, 29.42),
    Blip = {
        Title = 'Lottery Shop',
        Sprite = 77,
        Display = 4,
        Scale = 1.0,
        Color = 18
    },
    Text = {
        ViewDistance = 4,
        UseDistance = 1.0,
        Text = 'Lottery Shop'
    },
    Tickets = {
        ['Bronze'] = 100,
        ['Silver'] = 1000,
        ['Gold'] = 10000,
        ['Diamond'] = 100000
    },
    Menu = {
        Title = 'Lottery Shop',
        Align = 'right',
        Buy = 'Buy tickets',
        PayOff = 'Pay off ticket'
    },
    Messages = {
        Bought = 'You have purchased a lottery ticket in the category %s for $%s.',
        CantCarryMoreItems = 'You already carry too many items.',
        EnoughMoney = "You don't have enough money.",

        PayOff = 'You paid out a lottery ticket for %s in category %s.',
        NotWin = "Looks like you didn't win anything."
    }
}

Config.LotteryStart = {
    Start = {
        Hour = 20,
        Minutes = 15
    },
    DayInWeek = { -- Day in week when lottery will be drawn, Monday = 1, Tuesday = 2...
        Enabled = false, -- If this is set to false, lottery will be drawn every day at time in category Start above this
        Day = 1
    }
}

Config.Debug = {
    StartCommand = {
        Enabled = false, -- If true, command /startlottery will be enabled at server and client; RECOMMENDATION: If you server isn't Development server, set this to FALSE!
        TicketType = 'Bronze' -- Category what will be started by /startlottery
    }
}

-- Down you can implement your own notification exports


-- Client side notifications
function SendClientNotification(type, text)
    --[[if type == 'success' then
        exports['mythic_notify']:SendAlert('success', text)
    elseif type == 'error' then
        exports['mythic_notify']:SendAlert('error', text)
    elseif type == 'info' then
        exports['mythic_notify']:SendAlert('inform', text)
    end
    ]]
    ESX.ShowNotification(text)
end

-- Server side notifications
function SendServerNotification(source, type, text)
    --[[if type == 'success' then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = text })
    elseif type == 'error' then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = text })
    elseif type == 'info' then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = text })
    end
    ]]
    TriggerClientEvent('esx:showNotification', source, text)
end

-- Down you can implement your own chat message
function SendAnnouncement(characterName, price, ticketType)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.45vw; margin: 0.05vw; background-color: rgba(255, 153, 51, 0.5); border-radius: 6px;"><i class="fas fa-ticket-alt"></i> | <b>Lottery</b><p>{0} won ${1} in the category {2}.</p></div>',
        args = { characterName, price, ticketType }
    })
end
