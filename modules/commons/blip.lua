local blips = {}
function createNewBlip(blipData)
    local blip = AddBlipForCoord(blipData.coords.x, blipData.coords.y, blipData.coords.z)

    if blipData.sprite ~= nil then
        SetBlipSprite(blip, blipData.sprite)
    else
        SetBlipSprite(blip, 1)
    end

    if blipData.scale ~= nil then
        SetBlipScale(blip, blipData.scale)
    else
        SetBlipScale(blip, 0.8)
    end

    if blipData.colour ~= nil then
        SetBlipColour(blip, blipData.colour)
    else
        SetBlipColour(blip, 4)
    end

    if blipData.display ~= nil then
        SetBlipDisplay(blip, blipData.display)
    else
        SetBlipDisplay(blip, 4)
    end

    if blipData.isShortRange ~= nil then
        SetBlipAsShortRange(blip, blipData.isShortRange)
    else
        SetBlipAsShortRange(blip, true)
    end

    if blipData.alpha ~= nil then
        SetBlipAlpha(blip, blipData.alpha)
    end

    if blipData.friendly ~= nil then
        SetBlipAsFriendly(blip, blipData.friendly)
    end

    if blipData.isMissionCreatorBlip ~= nil then
        SetBlipAsMissionCreatorBlip(blip, blipData.isMissionCreatorBlip)
    end

    if blipData.isBright ~= nil then
        SetBlipBright(blip, blipData.isBright)
    end

    if blipData.category ~= nil then
        SetBlipCategory(blip, blipData.category)
    end

    if blipData.fade ~= nil then
        SetBlipFade(blip, blipData.fade.opacity, blipData.fade.duration)
    end

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipData.text)
    EndTextCommandSetBlipName(blip)
    if blipData.id then
        blips[blipData.id] = blip
    end
    return blip
end

function renameExistingBlip(blipData)
    if blipData.blip then
        if blipData.text then
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipData.text)
            EndTextCommandSetBlipName(blipData.blip)
        end
    end
end

return {
    createNewBlip = createNewBlip,
    renameExistingBlip = renameExistingBlip
}
