local client = {}

client.openMenu = function(id, title, content)
    local elements = {}
    for _, element in ipairs(content) do
        table.insert(elements, { label = element.name, value = element.id })
    end
    esx.UI.Menu.Open('default', GetCurrentResourceName(), id, {
        title = title,
        align = 'right',
        elements = elements
    }, function(data, menu)
        for _, element in ipairs(content) do
            if element.id == data.current.value then
                if element.callback() then
                    menu.close()
                end
                break
            end
        end
    end, function(data, menu)
        menu.close()
    end)
end

client.showHelpNotification = function(text)
    esx.ShowHelpNotification(text)
end

return client
