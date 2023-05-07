local function multiGsub(str, vals)
    local result = str
    for placeholder, replacement in pairs(vals) do
        result = string.gsub(result, placeholder, replacement)
    end
    return result
end

local function replace(table, placeholders)
    local temp = {}
    for key, value in pairs(table) do
        if type(value) == 'table' then
            temp[key] = replace(value, placeholders)
        elseif type(value) == 'string' then
            local result = multiGsub(value, placeholders)
            temp[key] = result
        end
    end
    return temp
end

function sendWebhook(webhook, placeholders)
    if webhook.url == nil then
        return
    end
    if placeholders ~= nil then
        webhook.embeds = replace(webhook.embeds, placeholders)
    end
    PerformHttpRequest(
        webhook.url,
        function(err, text, headers)
        end,
        'POST',
        json.encode(webhook),
        {
            ['Content-Type'] = 'application/json',
        }
    )
end

return {
    sendWebhook = sendWebhook
}
