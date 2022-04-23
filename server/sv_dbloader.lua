PossibleMySQLScripts = {
    ['oxmysql'] = true,
    ['ghattimysql'] = true,
    ['mysql-async'] = true
}

if not PossibleMySQLScripts[MySQLScript] then
    Error('MySQL script ' .. MySQLScript .. ' is not supported. Use oxmysql, ghattimysql or mysql-async.')
else
    Info('Successfuly registered ' .. MySQLScript .. ' as MySQL script.')
end
