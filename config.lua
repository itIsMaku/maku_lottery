Config = {
    Framework = 'esx',                     -- esx | qbcore
    FrameworkResourceName = 'es_extended', -- Name of framework resource

    Locations = {
        vector3(-47.21, -1755.72, 29.42)
    },

    Blip = {
        text = 'Lottery Shop',
        sprite = 77,
        display = 4,
        scale = 1.0,
        colour = 18
    },

    Categories = {
        {
            id = 'bronze',
            name = 'Bronze',
            price = 100,
        },
        {
            id = 'silver',
            name = 'Silver',
            price = 1000,
        },
        {
            id = 'gold',
            name = 'Gold',
            price = 10000,
        },
        {
            id = 'diamond',
            name = 'Diamond',
            price = 100000,
        }
    },

    Draw = {
        Day = nil,
        Hour = 19,
        Minutes = 15
    },

    Translations = {
        Marker = 'Lottery Shop',
        HelpText = 'Press ~INPUT_CONTEXT~ to open the lottery shop.',
        Notifications = {
            Bought = 'You have purchased a lottery ticket in the category %s for $%s.',
            CantCarryMoreItems = 'You already carry too many items.',
            EnoughMoney = "You don't have enough money.",

            PayOff = 'You paid out a lottery ticket for %s in category %s.',
            NotWin = "Looks like you didn't win anything."
        },
        Menu = {
            Title = 'Lottery Shop',
            Align = 'right',
            Buy = 'Buy tickets',
            PayOff = 'Pay off ticket'
        },
    }
}
