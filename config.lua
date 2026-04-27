-- ==================================================================

Config = {}

-------------------------------------------------
-- Discord integration                           
-------------------------------------------------
Config.discordWebhook        = true                                -- Enable / disable Discord support
Config.webhookUrl            = "YOUR_STOCKSUMMARY_WEBHOOK_URL"      -- Stock-summary embed URL (placeholder)
Config.transactionWebhookUrl = "YOUR_TRANSACTION_WEBHOOK_URL"       -- Transaction embed URL (placeholder)
Config.DiscordUpdateInterval = 60 * 60 * 4                         -- 4 hours
Config.Discordwebhookmanualcommand = "stocksummary"                -- Command that triggers summary

Config.DiscordMessages = {
    content              = "Stock-Market update",                   -- Embed text
    title                = "📈 Market Timer – Current Prices",
    noItems              = "There are no items at this location",
    locationContinuation = " (continued)"
}

Config.DiscordFormats = {
    saleDescription              = "Player sold %dx %s for $%.2f\nBase: $%.2f\nTax: $%.2f\nLocation: %s",
    saleWithConditionDescription = "Player sold %dx %s for $%.2f\nBase: $%.2f\nTax: $%.2f\nCondition: %.1f%%\nLocation: %s",
    saleTitle     = "Stock-Market – Sale",
    saleColor     = 15158332,                                       -- Red
    adminMessages = {
        disabledFeature     = "^1[Stock Market]^7 Discord feature disabled in config.",
        summarySent         = "^1[Stock Market]^7 Discord summary sent.",
        successMessage      = "Discord summary sent.",
        unauthorizedMessage = "Only admins can use this command."
    }
}

-------------------------------------------------
-- General settings                              
-------------------------------------------------
Config.Tax            = 10.0   -- Percentage withheld as tax
Config.DecayTolerance = 90     -- Minimum condition (%) for full price
Config.Debug          = false   -- Enable server-side debug output
Config.cooldownTime   = 0.5    -- Seconds between transactions

-------------------------------------------------
-- System messages                               
-------------------------------------------------
Config.SystemMessages = {
    initialDataLoaded = "[Stock Market] Initial data loaded.",
    noTranslation     = "No translations for '%s'."
}

-------------------------------------------------
-- Hot-keys                                       
-------------------------------------------------
Config.keys = {
    ["G"] = 0x760A9C6F -- Open trade menu
}


-------------------------------------------------
-- Translations (English only)                   
-------------------------------------------------
Config.Language = "en"
Config.Translations = {
    en = {
        blipname = "Stock Market",
        menuTitle = "Stock Market",
        buyOption = "---Buy %s ---",
        sellOption = "Sell %s",
        notEnoughMoney = "You don't have enough money!",
        noSpaceInInventory = "You don't have enough space in your inventory!",
        itemNotFound = "You don't have this item!",
        notEnoughItems = "You don't have enough items to sell!",
        priceTooLow = "You can't sell this item for that price!",
        buySuccess = "You bought %d x %s for $%.2f",
        sellSuccess = "You sold %d x %s for $%.2f",
        sellSuccessWithCondition = "You sold %d x %s (%d%% condition) for $%.2f",
        invalidStock = "This stock is not available at this location!",
        failedToRemoveWeapon = "Failed to remove weapon!",
        cooldownNotification = "Please wait %d seconds",
        promptText = "Press [G] to start trading",
        tax = "Tax",
        price = "Price",
        item = "Item",
        cannotCarryItem = "You cannot carry this many items.",
        closedMessage = "Market Closed",
        workingHours = "Working Hours: %d:00 - %d:00",
        marketClosedNotify = "The stock market is currently closed. Working hours are from %d:00 to %d:00.",
        backOption = "Back",
        invalidQuantity = "Please enter a valid quantity!",
        -- Menu translations
        buyQuantity = "Buy Quantity",
        sellQuantity = "Sell Quantity",
        confirm = "Confirm",
        selectQuantity = "Please select a quantity!",
        buyText = "Buy",
        sellText = "Sell",
        total = "Total",
        tradeInfo = "Buy/Sell",
        -- Price format translations
        priceFormat = "$%.2f/$%.2f",
        priceSlashFormat = "%s/%s",
        buySellLabel = "Buy/Sell"
    }
}

-------------------------------------------------
-- Example locations (3 different variants)       
-------------------------------------------------
Config.StockMarketLocations = {
    -- 1. Regular day market with opening hours
    {
        name              = "Example Stock Exchange",
        x = -819.28, y = -1278.56, z = 43.59,
        stocks            = { "bond1", "goldbar" },
        StoreHoursAllowed = true,
        StoreOpen         = 8,   -- 8 AM
        StoreClose        = 20,  -- 8 PM
        blipSprite        = -1567930587,
    },

    -- 2. 24/7 market without any hour checks
    {
        name              = "24/7 All-Day Market",
        x = -305.26,
        y = 775.42,
        z = 118.7,
        stocks            = { "iron", "apple" },
        StoreHoursAllowed = false,
        blipSprite        = -1567930587,
    },

    -- 3. Night market (opens in the evening & closes after midnight)
    {
        name              = "Night Market",
        x = 2825.44,
        y = -1230.16,
        z = 47.59,
        stocks            = { "hat", "healing_cream" },
        StoreHoursAllowed = true,
        StoreOpen         = 18,  -- 6 PM
        StoreClose        = 2,   -- 2 AM (next day)
        blipSprite        = -1567930587,
    },
}

-- Default blip appearance (client script can override colours)
Config.Blip = {
    sprite      = -1567930587,             -- Icon ID
    color       = "BLIP_MODIFIER_MP_COLOR_32", -- Generic colour
    colorOpen   = "BLIP_MODIFIER_MP_COLOR_32",
    colorClosed = "BLIP_MODIFIER_MP_COLOR_2",
}


-------------------------------------------------
-- Example items                                 
-------------------------------------------------
Config.Stocks = {
    bond1 = {
        label       = "Example Government Bond", -- Label
        price       = 10.00, -- Initial price
        item        = "bond1", -- Iten name from db
        priceChange = 1.0, -- Percentage change step (%)
        minPrice    = 0.01, --  Helps avoid negative value
    },

    goldbar = {
        label       = "Gold Bar",
        price       = 100.00,
        item        = "goldbar",
        priceChange = 1.0,
        minPrice    = 1.00,
    },

    iron = {
        label       = "Iron Ore",
        price       = 0.50,
        item        = "iron",
        priceChange = 1.0,
        minPrice    = 0.01,
    },

    apple = {
        label       = "Apple",
        price       = 1.00,
        item        = "apple",
        priceChange = 1.0,
        minPrice    = 0.01,
    },

    hat = {
        label       = "Hat",
        price       = 5.00,
        item        = "hat",
        priceChange = 1.0,
        minPrice    = 0.01,
    },

    healing_cream = {
        label       = "Healing Cream",
        price       = 2.50,
        item        = "healing_cream",
        priceChange = 1.0,
        minPrice    = 0.01,
    },
}

-- ================= End of template ===============================

             