local log = require 'modules.commons.log'

local frameworkName = Config.Framework
local frameworkResource = Config.FrameworkResourceName
local state = GetResourceState(frameworkResource)

if state ~= 'started' and state ~= 'starting' then
    log.error('Framework resource not started!')
    return
end

if IsDuplicityVersion() then
    return require('modules.framework.type.' .. frameworkName .. '.server')
end

return require('modules.framework.type.' .. frameworkName .. '.client')
