Webhooks = {
    bought = {
        url = 'https://discord.com/xyz',
        username = 'Lottery Purchase',
        data = {
            {
                ["color"] = 16776960,
                ["title"] = '**Purchase**',
                ["description"] = 'Player {name} has bought a lottery ticket, category {category}.',
                ["footer"] = {
                    ["text"] = 'Nickname: {name} | Identifier: {identifier}',
                }
            }
        }
    },
    draw = {
        url = 'https://discord.com/xyz',
        username = 'Lottery',
        data = {
            {
                ["color"] = 16776960,
                ["title"] = '**Win**',
                ["description"] = '{character} won ${price} in the {category} category.',
                ["footer"] = {
                    ["text"] = 'Good luck tomorrow!',
                }
            }
        }
    }
}
