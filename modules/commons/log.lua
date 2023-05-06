local prefixes = {
    ['error'] = '^1[ERROR] | ^0',
    ['warn'] = '^3[WARN] | ^0',
    ['info'] = '^2[INFO] | ^0',
    ['debug'] = '^5[DEBUG] | ^0',
    ['verbose'] = '^6[VERBOSE] | ^0'
}

log = {}

for name, prefix in pairs(prefixes) do
    log[name] = function(content, ...)
        print(prefix .. content:format(...))
    end
end

return log
