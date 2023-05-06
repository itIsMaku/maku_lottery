local server = {}
local esx = exports[Config.FrameworkResourceName]:getSharedObject()

local function player(playerId)
    return esx.GetPlayerFromId(playerId)
end

server.getMoney = function(playerId, type)
    return player(playerId).getAccount(type).money
end

server.removeMoney = function(playerId, type, amount)
    player(playerId).removeAccountMoney(type, amount)
end

server.addMoney = function(playerId, type, amount)
    player(playerId).addAccountMoney(type, amount)
end

server.getCharacterName = function(identifier)
    local player = esx.GetPlayerFromIdentifier(identifier)
    if player ~= nil then
        return player.get('firstName') .. ' ' .. player.get('lastName')
    end
    local row = MySQL.Sync.fetchScalar('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })
    if row == nil then
        return 'Unknown'
    end
    return row.firstname .. ' ' .. row.lastname
end

server.getIdentifier = function(playerId)
    return player(playerId).getIdentifier()
end

server.sendNotification = function(playerId, type, message)
    player(playerId).showNotification(message)
end

return server
