Config = {}

-------------------------------------------------
-- Discord integracija
-------------------------------------------------
Config.discordWebhook        = true                                -- Įjungti/išjungti Discord pranešimus
Config.webhookUrl            = "YOUR_STOCKSUMMARY_WEBHOOK_URL"      -- Bendros suvestinės webhook (naudoti /stocksummary)
Config.transactionWebhookUrl = "YOUR_TRANSACTION_WEBHOOK_URL"       -- Pirkimų/pardavimų webhook
Config.DiscordUpdateInterval = 60 * 60 * 4                         -- Automatinis suvestinės siuntimas (sekundėmis, pvz., kas 4 valandas)
Config.Discordwebhookmanualcommand = "stocksummary"                -- Komanda administracijai

Config.DiscordMessages = {
    content              = "Stock-Market update",
    title                = "📈 Market Timer – Current Prices",
    noItems              = "There are no items at this location",
    locationContinuation = " (continued)"
}

-------------------------------------------------
-- Bendrieji nustatymai
-------------------------------------------------
Config.Tax            = 10.0   -- Mokesčių procentas nuo sandorio
Config.DecayTolerance = 90     -- Minimali būklė (%) pilnai kainai gauti
Config.Debug          = false  -- Debug režimas konsolėje
Config.cooldownTime   = 0.5    -- Cooldown tarp sandorių (sekundėmis)

-------------------------------------------------
-- Klavišai
-------------------------------------------------
Config.keys = {
    ["G"] = 0x760A9C6F -- Meniu atidarymo klavišas
}

-------------------------------------------------
-- Kalbos pasirinkimas
-------------------------------------------------
Config.Language = "lt" -- "en" arba "lt"

-------------------------------------------------
-- Vertimai
-------------------------------------------------
Config.Translations = {
    en = {
        blipname = "Stock Market",
        menuTitle = "Stock Market",
        buyOption = "--- Buy %s ---",
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
        buyQuantity = "Buy Quantity",
        sellQuantity = "Sell Quantity",
        confirm = "Confirm",
        selectQuantity = "Please select a quantity!",
        buyText = "Buy",
        sellText = "Sell",
        total = "Total",
        tradeInfo = "Buy/Sell"
    },
    lt = {
        blipname = "Akcijų Birža",
        menuTitle = "Birža",
        buyOption = "--- Pirkti %s ---",
        sellOption = "Parduoti %s",        
        notEnoughMoney = "Neturite pakankamai pinigų!",
        noSpaceInInventory = "Neturite vietos inventoriuje!",
        itemNotFound = "Neturite prekės!",
        notEnoughItems = "Neturite ką parduoti!",
        priceTooLow = "Nėra kam parduoti!", 
        buySuccess = "Pirkote %d x %s už $%.2f",
        sellSuccess = "Parduota %d x %s už $%.2f",
        sellSuccessWithCondition = "Parduota %d x %s (%d%% būklė) už $%.2f",
        invalidStock = "Ši prekė šioje vietoxtoje neparduodama!",
        cooldownNotification = "Prašome palaukti %d sekundžių",
        promptText = "Spauskite [G] prekiauti",
        tax = "Mokesčiai",
        price = "Kaina",
        item = "Prekė",
        cannotCarryItem = "Negalite tiek panešti.",
        closedMessage = "Birža uždaryta",
        workingHours = "Darbo valandos: %d:00 - %d:00",
        marketClosedNotify = "Birža šiuo metu uždaryta. Darbo valandos: %d:00 - %d:00.",
        backOption = "Atgal",
        invalidQuantity = "Įveskite teisingą kiekį!",
        buyQuantity = "Pirkti kiekį",
        sellQuantity = "Parduoti kiekį",
        confirm = "Patvirtinti",
        selectQuantity = "Pasirinkite kiekį!",
        buyText = "Pirkti",
        sellText = "Parduoti",
        total = "Iš viso",
        tradeInfo = "Pirkti/Parduoti"
    }
}

-------------------------------------------------
-- Prekybos vietos
-------------------------------------------------
Config.StockMarketLocations = {
    {
        name = "West Elizabeth Akcijų Birža",
        x = -819.28, y = -1278.56, z = 43.59,
        stocks = { "bond1", "bond3", "goldnugget", "goldbar" },
        StoreHoursAllowed = true,
        StoreOpen = 8,
        StoreClose = 20
    },
    {
        name = "New Hanover Akcijų Birža",
        x = -305.26, y = 775.42, z = 118.7,
        stocks = { "bond2", "bond3", "goldnugget", "goldbar" },
        StoreHoursAllowed = false
    },
    {
        name = "Sisikos Parduotuvė",
        x = 3372.07, y = -654.38, z = 46.42,
        stocks = { "goldnugget", "cotton", "dogfood", "milk", "eggs", "Wood", "iron", "consumable_coffee_gnds_reg" },
        StoreHoursAllowed = false
    },
    {
        name = "Lemoyne Žaliavų Birža",
        x = 1380.8, y = -1311.26, z = 77.42,
        stocks = { "iron", "coal", "copper", "sulfur", "ironbar", "copperbar", "crate", "skin", "Feather", "Wood", "hwood", "woodlog", "cotton", "wool", "tobacco", "sand", "fertilizer", "petrol" },
        StoreHoursAllowed = true,
        StoreOpen = 6,
        StoreClose = 22
    },
    {
        name = "Valentine Prekių Parduotuvė",
        x = -322.31, y = 803.92, z = 117.88,
        stocks = { "canteen", "dogfood", "pen", "notebook", "telegram", "hairpomade", "WEAPON_MELEE_LANTERN", "lumberaxe", "pickaxe2", "goldpan" },
        StoreHoursAllowed = true,
        StoreOpen = 7,
        StoreClose = 21
    }
}

-------------------------------------------------
-- Blip nustatymai
-------------------------------------------------
Config.Blip = {
    sprite = -1567930587,
    color = 'BLIP_MODIFIER_MP_COLOR_32',
    colorOpen = 'BLIP_MODIFIER_MP_COLOR_32',
    colorClosed = 'BLIP_MODIFIER_MP_COLOR_2'
}

-------------------------------------------------
-- Prekių / Akcijų nustatymai
-------------------------------------------------
Config.Stocks = {
    ["bond1"] = { label = "West Elizabeth Obligacijos", price = 10.00, item = "bond1", priceChange = { increase = 0.33, decrease = 0.33 }, minPrice = 0.01 },
    ["bond2"] = { label = "New Hanover Obligacijos", price = 10.00, item = "bond2", priceChange = { increase = 0.36, decrease = 0.36 }, minPrice = 0.01 },
    ["bond3"] = { label = "Cornwall Co. Akcijos", price = 10.00, item = "bond3", priceChange = { increase = 0.11, decrease = 0.11 }, minPrice = 0.01 },
    ["goldnugget"] = { label = "Aukso Grynuoliai", price = 1.00, item = "goldnugget", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["goldbar"] = { label = "Aukso Luitai", price = 100.00, item = "goldbar", priceChange = { increase = 1.00, decrease = 1.00 }, minPrice = 1.00 },
    ["iron"] = { label = "Geležis", price = 0.50, item = "iron", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["coal"] = { label = "Anglis", price = 0.50, item = "coal", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["copper"] = { label = "Varis", price = 0.50, item = "copper", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["sulfur"] = { label = "Siera", price = 0.50, item = "sulfur", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["ironbar"] = { label = "Plienas", price = 10.00, item = "ironbar", priceChange = { increase = 0.10, decrease = 0.11 }, minPrice = 0.10 },
    ["copperbar"] = { label = "Vario Luitas", price = 100.00, item = "copperbar", priceChange = { increase = 1.00, decrease = 1.00 }, minPrice = 1.00 },
    ["crate"] = { label = "Ūkininko Dėžės", price = 50.00, item = "crate", priceChange = { increase = 0.50, decrease = 0.50 }, minPrice = 1.00 },
    ["skin"] = { label = "Oda", price = 1.00, item = "skin", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["Feather"] = { label = "Plunksnos", price = 1.00, item = "Feather", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["Wood"] = { label = "Medienos Gaminiai", price = 0.50, item = "Wood", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["hwood"] = { label = "Medienos Lentos", price = 1.50, item = "hwood", priceChange = { increase = 0.02, decrease = 0.02 }, minPrice = 0.01 },
    ["woodlog"] = { label = "Medienos Rąstai", price = 3.00, item = "woodlog", priceChange = { increase = 0.03, decrease = 0.03 }, minPrice = 0.01 },
    ["petrol"] = { label = "Nafta", price = 10.00, item = "petrol", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["sand"] = { label = "Smėlis", price = 0.50, item = "sand", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["apple"] = { label = "Obuoliai", price = 5.00, item = "apple", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["tobacco"] = { label = "Tabakas", price = 0.50, item = "tobacco", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["cotton"] = { label = "Medvilnė", price = 0.50, item = "cotton", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["milk"] = { label = "Pienas", price = 0.50, item = "milk", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["eggs"] = { label = "Kiaušiniai", price = 0.50, item = "eggs", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 },
    ["dogfood"] = { label = "Šunų Maistas", price = 0.50, item = "dogfood", priceChange = { increase = 0.01, decrease = 0.01 }, minPrice = 0.01 }
}
