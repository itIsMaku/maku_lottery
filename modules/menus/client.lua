local framework = require 'modules.framework.resolve'

function openLotteryShop()
    framework.openMenu('shop', Config.Translations.Menu.Title, {
        {
            id = 'buy',
            name = Config.Translations.Menu.Buy,
            callback = function()
                openCategoriesMenu(function(category)
                    TriggerServerEvent('maku_lottery:buyTicket', category)
                    return true
                end, true)
                return false
            end
        },
        {
            id = 'payoff',
            name = Config.Translations.Menu.PayOff,
            callback = function()
                openCategoriesMenu(function(category)
                    TriggerServerEvent('maku_lottery:payOff', category)
                    return true
                end, false)
                return false
            end
        }
    })
end

function openCategoriesMenu(callback, priceVisible)
    local content = {}
    for _, category in ipairs(Config.Categories) do
        local name = category.name
        if priceVisible then
            name = name .. ' ($' .. category.price .. ')'
        end
        table.insert(content, {
            id = category.id,
            name = name,
            callback = function()
                return callback(category.id)
            end
        })
    end
    framework.openMenu('categorismenu', Config.Translations.Menu.Title, content)
end

return {
    openLotteryShop = openLotteryShop,
    openCategoriesMenu = openCategoriesMenu
}
