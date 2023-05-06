local log = require 'modules.commons.log'

local tables = {}

tables.contains = function(list, element)
    for _, value in pairs(list) do
        if value == element then
            return true
        end
    end
    return false
end

tables.index_of = function(list, element)
    for index, value in pairs(list) do
        if value == element then
            return index
        end
    end
    return nil
end

tables.retreive_inner = function(list, key, expected)
    for index, value in pairs(list) do
        if value[key] == expected then
            return value
        end
    end
    return nil
end

tables.remove_value = function(list, element)
    local index = table.index_of(list, element)
    if index then
        table.remove(list, index)
    end
end

tables.merge = function(list1, list2)
    for _, value in pairs(list2) do
        table.insert(list1, value)
    end
end

tables.merge_unique = function(list1, list2)
    for _, value in pairs(list2) do
        if not table.contains(list1, value) then
            table.insert(list1, value)
        end
    end
end

tables.copy = function(list)
    local copy = {}
    for _, value in pairs(list) do
        table.insert(copy, value)
    end
    return copy
end

tables.print = function(list)
    print(json.encode(list, { indent = true }))
end

tables.size = function(list)
    local size = 0
    for _, _ in pairs(list) do
        size = size + 1
    end
    return size
end

tables.dump = function(list)
    log.debug("Dumping table:")
    for key, value in pairs(list) do
        log.verbose(key .. " = " .. tostring(value))
    end
    log.debug("End of table dump.")
end

return tables
