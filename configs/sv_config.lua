Webhooks = {}

Webhooks = {
    Bought = {
        Enabled = true,
        URL = 'PUT_YOUR_WEBHOOK',
        Color = 16776960, -- (Decimal color), converting tool = https://convertingcolors.com/
        Username = 'Lottery Purchase',
        Title = '**Purchase**',
        Description = 'Player %s has bought a lottery ticket, category %s.',
        Footer = 'Nickname: %s | Identifier: %s'
    },
    Run = {
        Enabled = true,
        URL = 'PUT_YOUR_WEBHOOK',
        Color = 16776960, -- (Decimal color), converting tool = https://convertingcolors.com/
        Username = 'Lottery',
        Title = '**Win**',
        Description = '%s won $%s in the %s category.',
        Footer = 'Good luck tomorrow!'
    }
}

MySQLScript = 'mysql-async' -- mysql-async / oxmysql  / ghattimysql
