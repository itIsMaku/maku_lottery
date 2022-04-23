local scriptName = GetCurrentResourceName()

function Info(str)
    print('^2[' .. scriptName .. ']' .. ' ^0| ' .. str)
end

function Warn(str)
    print('^3[' .. scriptName .. ']' .. ' ^0| ' .. str)
end

function Error(str)
    print('^1[' .. scriptName .. ']' .. ' ^0| ' .. str)
end
