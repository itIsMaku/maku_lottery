ESX = nil

local blip = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.ESX.SharedObjectTrigger, function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    CreateLotteryShopBlip()
end)

function OpenLotteryShop()
    local elements = {
        { label = Config.LotteryShop.Menu.Buy, value = 'buy' },
        { label = Config.LotteryShop.Menu.PayOff, value = 'payoff' }
    }
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'lotteryshop', {
            title    = Config.LotteryShop.Menu.Title,
            align    = Config.LotteryShop.Menu.Align,
            elements = elements
        },
        function(data, menu)
            if data.current.value == 'buy' then
                OpenBoughtMenu()
            elseif data.current.value == 'payoff' then
                OpenPayOffMenu()
            end
        end, function(data, menu)
            menu.close()
        end
    )
end

function OpenBoughtMenu()
    local elements = {}
    for key, value in pairs(Config.LotteryShop.Tickets) do
        table.insert(elements, { label = key .. '<span style="color:limegreen;">$' .. value .. '</span>', value = key })
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'boughtmenu', {
            title    = Config.LotteryShop.Menu.Title,
            align    = Config.LotteryShop.Menu.Align,
            elements = elements
        },
        function(data, menu)
            menu.close()
            for key, value in pairs(Config.LotteryShop.Tickets) do
                if data.current.value == key then
                    TriggerServerEvent('codely_lottery:buyTicket', key)
                end
            end
        end, function(data, menu)
            menu.close()
        end
    )
end

function OpenPayOffMenu()
    local elements = {}
    for key, value in pairs(Config.LotteryShop.Tickets) do
        table.insert(elements, { label = key, value = key })
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'payoffmenu', {
            title    = Config.LotteryShop.Menu.Title,
            align    = Config.LotteryShop.Menu.Align,
            elements = elements
        },
        function(data, menu)
            ESX.UI.Menu.CloseAll()
            for key, value in pairs(Config.LotteryShop.Tickets) do
                if data.current.value == key then
                    TriggerServerEvent('codely_lottery:payOff', key)
                end
            end
        end, function(data, menu)
            menu.close()
        end
    )
end

Citizen.CreateThread(function()
    while true do
        if #(GetEntityCoords(PlayerPedId()) - vector3(Config.LotteryShop.Location)) < Config.LotteryShop.Text.ViewDistance then
            CreateUsable3DText(Config.LotteryShop.Location, Config.LotteryShop.Text.ViewDistance, Config.LotteryShop.Text.UseDistance, Config.LotteryShop.Text.Text)
            if #(GetEntityCoords(PlayerPedId()) - vector3(Config.LotteryShop.Location)) < Config.LotteryShop.Text.UseDistance
                and
                IsControlJustReleased(0, 38)
            then
                OpenLotteryShop()
            end
        else
            Citizen.Wait(500)
        end
        Wait(0)
    end
end)
