if MySQLScript == 'oxmysql' then
    MySQL = {}

    MySQL.Sync = {}

    MySQL.Async = {}

    MySQL.Sync.fetchAll = function(sqlQuery, table, callback)
        return exports['oxmysql']
            :executeSync(
                sqlQuery,
                table
            )
    end

    MySQL.Sync.execute = function(sqlQuery, table, callback)
        return exports['oxmysql']
            :executeSync(
                sqlQuery,
                table
            )
    end

    MySQL.Async.execute = MySQL.Sync.execute
end
