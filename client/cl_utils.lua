function Create3DText(vector, text)
    local onScreen, _x, _y = World3dToScreen2d(vector.x, vector.y, vector.z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextOutline()
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0135, 0.025 + factor, 0.03, 135, 206, 250, 68)
    end
end

function CreateUsable3DText(vector, displayDistance, canUseDistance, text)
    local coords = GetEntityCoords(PlayerPedId())
    if #(coords - vector) < displayDistance and #(coords - vector) > canUseDistance then
        Create3DText(vector, text)
    elseif #(coords - vector) < canUseDistance then
        Create3DText(vector, '[E] ' .. text)
    end
end
