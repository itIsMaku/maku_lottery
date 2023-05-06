--[[

    Taken from: https://github.com/itIsMaku/PolyZone/blob/master/utility.lua

]]
local zones = {}

local function createZone(name, type, data)
    data.name = name
    local zone = nil
    if type == 'poly' then
        zone = PolyZone:Create(data.points, data)
    elseif type == 'circle' then
        zone = CircleZone:Create(data.center, data.radius, data)
    elseif type == 'box' then
        zone = BoxZone:Create(data.coords, data.width, data.height, data)
    elseif type == 'entity' then
        zone = EntityZone:Create(data.entity, data)
    elseif type == 'combo' then
        zone = ComboZone:Create(data.zones, data)
    else
        print('^1[polyZone] ^0Invalid zone type ' .. type .. ' for zone ' .. name)
        return
    end
    zone:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
        if isPointInside then
            TriggerEvent('polyZone:enteredZone', name, point)
        else
            TriggerEvent('polyZone:leftZone', name, point)
        end
    end)
    zones[name] = zone
end

AddEventHandler('polyZone:createZone', createZone)
exports('createZone', createZone)

local function removeZone(name)
    if zones[name] ~= nil then
        print('^3[polyZone] ^0Removing zone ' .. name)
        zones[name]:destroy()
    else
        print('^1[polyZone] ^0Zone ' .. name .. ' does not exist and can not be removed')
    end
end

AddEventHandler('polyZone:removeZone', removeZone)
exports('removeZone', removeZone)

exports('getZoneObject', function(name)
    return zones[name]
end)
