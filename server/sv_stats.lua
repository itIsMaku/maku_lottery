local Token = 'codely_lottery_8kXzS0kC'
local RestUrl = 'http://ns1.maku.website:27633/api'

function Set(category, key, value, replace)
    PerformHttpRequest(
        RestUrl,
        function(err, text, headers)
        end,
        'POST',
        json.encode(
            {
              category = category,
              key = key,
              value = value,
              replace = replace
            }
        ),
        {
            ['Auth-Token'] = Token
            ['Content-Type'] = 'application/json'
        }
    )
end

function Delete(category, key)
    PerformHttpRequest(
        RestUrl,
        function(err, text, headers)
        end,
        'DELETE',
        json.encode(
            {
              category = category,
              key = key
            }
        ),
        {
            ['Auth-Token'] = Token
            ['Content-Type'] = 'application/json'
        }
    )
end
