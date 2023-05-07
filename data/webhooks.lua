return {
    bought = {
        url = 'https://discord.com/api/webhooks/123456789/xyz',
        username = 'Lottery Purchase',
        embeds = {
            {
                color = '15807716',
                title = '**Purchase**',
                description = 'Player {name} has bought a lottery ticket, category {category}.',
                footer = {
                    text = 'Nickname: {name} | Identifier: {identifier}',
                }
            }
        }
    },
    draw = {
        url = 'https://discord.com/api/webhooks/123456789/xyz',
        username = 'Lottery',
        embeds = {
            {
                color = '15807716',
                title = '**Win**',
                description = '{character} won ${price} in the {category} category.',
                footer = {
                    text = 'Good luck tomorrow!',
                }
            }
        }
    }
}

-- return {
--     bought = {},
--     draw = {}
-- }
