local function replace(table, placeholders)
    for key, value in pairs(table) do
        if type(value) == 'table' then
            table[key] = replace(value, placeholders)
        elseif type(value) == 'string' then
            for placeholder, replacement in pairs(placeholders) do
                table[key] = string.gsub(value, placeholder, replacement)
            end
        end
    end
    return table
end

function sendWebhook(webhook, placheolders)
    if placeholders ~= nil then
        webhook.data = replace(webhook.data, placeholders)
    end
    PerformHttpRequest(
        webhook.url,
        function(err, text, headers)
        end,
        'POST',
        json.encode(webhook.data),
        {
            ['Content-Type'] = 'application/json',
        }
    )
end

return {
    sendWebhook = sendWebhook
}
