Config = {}

--- Discord
Config.discordWebhook = true
Config.webhookUrl = "https://discord.com/api/webhooks/1342091914824126494/pMSYlbeEWRtByfjO74AH8IMxW0xnZt3MYTzxUzIjCB6mmyNcxJhb_k3NQT0SHYKNYnSO" -- Tik stocksummary komandai
Config.transactionWebhookUrl = "https://discord.com/api/webhooks/1175074142488371231/7pJkMMOp207AOQvj_DEuHo5ovzz4XSJRlrwi1OwKFhTXCQFWE_Q9vmd-DviQ7Q8Tj2FL" -- Pirkimams ir pardavimams

Config.DiscordUpdateInterval = 60 * 60 * 4 --- in seconds (3 hour) 
Config.Discordwebhookmanualcommand = 'stocksummary'


-- Tax
Config.Tax = 10.00 -- Percentage of transaction as tax (e.g., 0.5% tax)


Config.DecayTolerance = 90 -- Minimali degradacija procentais, nuo kurios mokama pilna kaina

Config.Debug = false -- Nustatykite į true, jei norite matyti debug pranešimus


--- Keys
Config.keys = {
    ["G"] = 0x760A9C6F -- Menu open key
}

-- Trading location
Config.StockMarketLocations = {  -- 
    {
        name = "West Elizabeth Akciju Birža ", -- blip name
        x = -819.28, y = -1278.56, z = 43.59,
        stocks = { "bond1", "bond3", "goldnugget", "goldbar"} -- Only these stocks are available at this location
    },
    {
        name = "New Hanover Akciju Birža",
        x = -305.26, y = 775.42, z = 118.7,
        stocks = { "bond2", "bond3", "goldnugget", "goldbar"} 
    },
    {
        name = "Sisikos Parduotuve",
        x = 3372.07, y = -654.38, z = 46.42,
        stocks = {  "goldnugget" , "cotton", "dogfood","milk","eggs", "Wood", "iron", "consumable_coffee_gnds_reg" } 
    },
    {
        name = "Lemone Žaliavu Birža",
        x = 1380.8, y = -1311.26, z = 77.42,
        stocks = {             
            "iron", "coal", "copper", "sulfur", 
            "ironbar", "copperbar", "crate",
            "skin", "Feather", "Wood", "hwood", "woodlog", "cotton", "wool", "tobacco", "sand", "fertilizer", "petrol"
        }
    },
    {
        name = "West Elizabeth Daržoviu Birža",
        x = -756.42, y = -1322.79, z = 43.72,
        stocks = {             
            "apple", "Wild_Carrot", "sugar", "salt",  "consumable_coffee_gnds_reg", "Hop", "Parasol_Mushroom",  
            "wheat", "corn", "Coca", "Grape", "potato", "Wild_Mint", "Rams_Head", "Indigo", "Tomato", "Cabbage", "Onion", "Pepper",
            
        }
    },
    {

        name = "Pigus Rubu Parduotuve",
        x = -5485.83, y = -2938.1, z = -0.4,
        stocks = {
            "hat", "shirt", "pants", "boots", "vest", "coat", "glove", "mask", "neckwear", "suspenders", "poncho", "cloak", "bracelet", 
            "gunbelt", "belt", "buckle", "holster", "chap", "spur", "accessory", "satchel", "gauntlet", "eyewear", "armor", "spats", 
            "jewelry_rings_left", "jewelry_rings_right", "neckties", "loadouts", "coats_closed"
        }
    },

    {
        name = "Mexicania Žoleliu Birža",
        x = -3660.65, y = -2595.58, z = -13.31,
        stocks = {             
            'Texas_Bonnet',
            'Black_Currant',
            'Desert_Sage',
            'Choc_Daisy',
            'American_Ginseng',
            'Oleander_Sage',
            'Burdock_Root',
            'Wild_Feverfew',
            'Bitter_Weed',
            'Golden_Currant',
            'harrietum_officinalis',
            'Evergreen_Huckleberry',
            'Bay_Bolete',
            'Red_Sage',
            'Wisteria',
            'Blood_Flower',
            'Wintergreen_Berry',
            'Cardinal_Flower',
            'Bulrush',
            'English_Mace',
            'Wild_Rhubarb',
            'Yarrow',
            'Red_Raspberry',
            'Violet_Snowdrop',
            'Black_Berry',
            'Prairie_Poppy',
            'Hummingbird_Sage',
            'Agarita',
            'Chanterelles',
            'Oregano',
            'Creeking_Thyme',
            'Creekplum',
            'Alaskan_Ginseng',
            'Milk_Weed',
            'Indian_Tobacco'
        }
    },

    {
        name = "New Hanover Maisto Birža",
        x = -334.42, y = 764.54, z = 116.52,
        stocks = {             
             "bird", "pork", "beef", "venison", "biggame", "stringy", "game", "Mutton", "consumable_meat_succulent_fish_cooked", "eggs", "milk", "dogfood", "animal_rat","acid"
            
        }
    },
    -- {
    --     name = "Ginklų Parduotuvė",
    --     x = 2716.0, y = -1285.0, z = 49.6,
    --     stocks = { "WEAPON_REPEATER_CARBINE", "WEAPON_RIFLE_VARMINT", "WEAPON_REVOLVER_CATTLEMAN" }
    -- },
    {
        name = "Valentine Prekių Parduotuvė",
        x = -322.31, y = 803.92, z = 117.88, -- Valentine miesto koordinatės
        stocks = {
            "canteen", "dogfood", "pen", "notebook", "telegram", "hairpomade", "WEAPON_MELEE_LANTERN", "lumberaxe", "pickaxe2", "goldpan",
        }
    },
    {
        name = "Valentine Ginkline",
        x = -280.86, y = 780.74, z = 119.53,
        stocks = {
            "WEAPON_MELEE_KNIFE", "WEAPON_LASSO", "WEAPON_BOW", "cleanshort", "WEAPON_REVOLVER_CATTLEMAN", "WEAPON_RIFLE_VARMINT",
            "ammovarmint", "ammorevolvernormal", "ammoriflenormal", "ammopistolnormal", "ammoshotgunnormal", "ammorepeaternormal", "ammoarrowsmallgame"
        }
    },
}
--- Blip settings
Config.Blip = {
    sprite = -1567930587, -- https://filmcrz.github.io/blips/
    color = 'BLIP_MODIFIER_MP_COLOR_32' -- Spalva
}


Config.cooldownTime = 0.5 --- Seconds. Globar Cooldown between transactions. Increases on long db queries.

--- Language
Config.Language = "lt" -- Pasirinkite numatytąją kalbą
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
        cooldownNotification = "Please wait %d seconds",
        promptText = "Press [G] to start trading",
        tax = "Tax",
        ---- Discordhookmesage
        price = "Price",
        item = "Goods",    },
    lt = {
        blipname = "Akciju Birža",
        menuTitle = "Birža",
        buyOption = "---Pirkti %s ---",
        sellOption = "Parduoti %s",        
        noSpaceInInventory = "Neturite vietos inventoriuje!",
        itemNotFound = "Neturite prekes!",
        notEnoughItems = "Neturite ka parduoti!",
        priceTooLow = "Nera kam parduoti!", 
        cooldownNotification = "Prašome palaukti %d sekundžiu",
        promptText = "Spauskite [G] prekiauti",
        notEnoughMoney = "Neturite pakankamai pinigu!",
        buySuccess = "Pirkote %d x %s už $%.2f",
        sellSuccess = "Parduota %d x %s už $%.2f",
        tax = "Tax",
        ---- Discordhookmesage
        price = "Kaina",
        item = "Prekė",
    }
}

--- Stock market items 
Config.Stocks = {
    ["bond1"] = { -- same as item
        label = "West Elizabeth Obligacijos", -- Label
        price = 10.00, -- Initial price
        item = "bond1", -- Iten name from db
        priceChange = { increase = 0.33, decrease = 0.33 }, -- Price change affter each transaction // 
        minPrice = 0.01 -- Market will crash on this price. Helps avoid negative value
    },
    ["bond2"] = { 
        label = "New Hanover Obligacijos",  
        price = 10.00,
        item = "bond2",
        priceChange = { increase = 0.36, decrease = 0.36 },
        minPrice = 0.01 -- 
    },
    ["bond3"] = { 
        label = "Cornwall Co. Akcijos",  --- 
        price = 10.00,
        item = "bond3",
        priceChange = { increase = 0.11, decrease = 0.11 },
        minPrice = 0.01 -- 
    },
    ["goldnugget"] = { 
        label = "Aukso Grynuoliai",  --- 
        price = 1.00,
        item = "goldnugget",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["goldbar"] = { 
        label = "Aukso Luitai",  --- 
        price = 100.00,
        item = "goldbar",
        priceChange = { increase = 1.00, decrease = 1.00 },
        minPrice = 1.00 -- 
    },
------------------ Could be added not only stocks ------------------
    ["iron"] = { 
        label = "Geležis",  
        price = 0.50,
        item = "iron",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["coal"] = { 
        label = "Anglis",  
        price = 0.50,
        item = "coal",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["copper"] = { 
        label = "Varis",  --- 
        price = 0.50,
        item = "copper",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["sulfur"] = { 
        label = "Siera",  --- 
        price = 0.50,
        item = "sulfur",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["ironbar"] = { 
        label = "Plienas",  
        price = 10.00,
        item = "ironbar",
        priceChange = { increase = 0.10, decrease = 0.11 }, 
        minPrice = 0.10 -- 
    },
    ["copperbar"] = { 
        label = "Vario Luitas",  --- 
        price = 100.00,
        item = "copperbar",
        priceChange = { increase = 1.00, decrease = 1.00 },
        minPrice = 1.00 -- 
    },
    ["crate"] = { 
        label = "Ukininko Dežes",  
        price = 50.00,
        item = "crate",
        priceChange = { increase = 0.50, decrease = 0.50 },
        minPrice = 1.00 -- 
    },
    ["skin"] = { 
        label = "Oda",  
        price = 1.00,
        item = "skin",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["Feather"] = { 
        label = "Plunksnos",  
        price = 1.00,
        item = "Feather",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["Wood"] = { 
        label = "Medienos Gaminiai",  
        price = 0.50,
        item = "Wood",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["hwood"] = { 
        label = "Medienos Lentos",  
        price = 1.50,
        item = "hwood",
        priceChange = { increase = 0.02, decrease = 0.02 }, 
        minPrice = 0.01 -- 
    },
    ["woodlog"] = { 
        label = "Medienos Rastai",  
        price = 3.00,
        item = "woodlog",
        priceChange = { increase = 0.03, decrease = 0.03 }, 
        minPrice = 0.01 -- 
    },
    ["petrol"] = { 
        label = "Nafta",  
        price = 10.00,
        item = "petrol",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["sand"] = { 
        label = "Smelis",  
        price = 0.50,
        item = "sand",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
   ----------------- Extra items -----------------
    ["apple"] = { 
        label = "Obuoliai",  
        price = 5.00,
        item = "apple",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["Wild_Carrot"] = { 
        label = "Morkos",  
        price = 5.00,
        item = "Wild_Carrot",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.00 -- 
    },
    ["sugar"] = {  
        label = "Cukrus",
        price = 5.00,
        item = "sugar",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["tobacco"] = { 
        label = "Tabakas",  
        price = 0.50,
        item = "tobacco",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["Hop"] = { 
        label = "Apyniai",  
        price = 0.50,
        item = "Hop",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["Parasol_Mushroom"] = { 
        label = "Grybai",  
        price = 0.50,
        item = "Parasol_Mushroom",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["cotton"] = { 
        label = "Medvilne",  
        price = 0.50,
        item = "cotton",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["wheat"] = { 
        label = "Kvieciai",  
        price = 0.50,
        item = "wheat",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["corn"] = { 
        label = "Kukuruzai",  
        price = 0.50,
        item = "corn",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["Coca"] = { 
        label = "Kakava",  
        price = 0.50,
        item = "Coca",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },    
    ["Grape"] = { 
        label = "Vynuoges",
        price = 0.50,
        item = "Grape",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["potato"] = { 
        label = "Bulves", 
        price = 0.50,
        item = "potato",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["wool"] = { 
        label = "Vilna",  
        price = 0.50,
        item = "wool",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },
    ["Wild_Mint"] = { 
        label = "Meta",  
        price = 0.50,
        item = "Wild_Mint",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Rams_Head"] = { 
        label = "Kuokštine grifole",  
        price = 0.50,
        item = "Rams_Head",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Indigo"] = { 
        label = "Indigo",  
        price = 0.50,
        item = "Indigo",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Tomato"] = { 
        label = "Pomidorai",  
        price = 0.50,
        item = "Tomato",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Cabbage"] = { 
        label = "Kopustai",  
        price = 0.50,
        item = "Cabbage",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Onion"] = { 
        label = "Svogunai",  
        price = 0.50,
        item = "Onion",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Pepper"] = { 
        label = "Pipirai",  
        price = 0.50,
        item = "Pepper",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["consumable_coffee_gnds_reg"] = { 
        label = "Kava",  
        price = 0.50,
        item = "consumable_coffee_gnds_reg",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["fertilizer"] = { 
        label = "Mešlas",  
        price = 0.01,
        item = "fertilizer",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },--
    ["salt"] = { 
        label = "Druska",  
        price = 5.50,
        item = "salt",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01 -- 
    },

    -------------- Maistas ------------------

    ["bird"] = { 
        label = "Paukštiena",  
        price = 0.50,
        item = "bird",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["pork"] = { 
        label = "Kiauliena",  
        price = 0.50,
        item = "pork",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["beef"] = { 
        label = "Jautiena",  
        price = 0.50,
        item = "beef",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["venison"] = { 
        label = "Elniena",  
        price = 0.50,
        item = "venison",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["biggame"] = { 
        label = "Stambi Žveriena",  
        price = 0.50,
        item = "biggame",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["stringy"] = { 
        label = "File",  
        price = 0.50,
        item = "stringy",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["game"] = { 
        label = "Žveriena",  
        price = 0.50,
        item = "game",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Mutton"] = { 
        label = "Aviena",  
        price = 0.50,
        item = "Mutton",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["consumable_meat_succulent_fish_cooked"] = { 
        label = "Žalia Žuvis",  
        price = 0.50,
        item = "consumable_meat_succulent_fish_cooked",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["eggs"] = { 
        label = "Kiaušiniai",  
        price = 0.50,
        item = "eggs",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["milk"] = { 
        label = "Pienas",  
        price = 0.50,
        item = "milk",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["dogfood"] = { 
        label = "Šunu Maistas",  
        price = 0.50,
        item = "dogfood",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01,
    },
    ["animal_rat"] = { 
        label = "Žiurkiu Mesa",  
        price = 0.50,
        item = "animal_rat",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["acid"] = { 
        label = "Rūgštis",  
        price = 0.50,
        item = "acid",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ------ Žolelės ------
    ["Texas_Bonnet"] = { 
        label = "Lubinas",  
        price = 1.00,
        item = "Texas_Bonnet",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Black_Currant"] = { 
        label = "Juodieji serbentai",  
        price = 1.00,
        item = "Black_Currant",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Desert_Sage"] = { 
        label = "Dykumu šalavijas",  
        price = 1.00,
        item = "Desert_Sage",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Choc_Daisy"] = { 
        label = "Berlandiera",  
        price = 1.00,
        item = "Choc_Daisy",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["American_Ginseng"] = { 
        label = "Amerikietiškas ženšenis",  
        price = 1.00,
        item = "American_Ginseng",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Oleander_Sage"] = { 
        label = "Oleandro šalavijas",  
        price = 1.00,
        item = "Oleander_Sage",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Burdock_Root"] = { 
        label = "Varnaleša",  
        price = 1.00,
        item = "Burdock_Root",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Wild_Feverfew"] = { 
        label = "Laukine ramunele",  
        price = 1.00,
        item = "Wild_Feverfew",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Bitter_Weed"] = { 
        label = "Karcioji saulaine",  
        price = 1.00,
        item = "Bitter_Weed",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Golden_Currant"] = { 
        label = "Geltonasis Serbentas",  
        price = 1.00,
        item = "Golden_Currant",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["harrietum_officinalis"] = { 
        label = "Šaltalankis",  
        price = 1.00,
        item = "harrietum_officinalis",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Evergreen_Huckleberry"] = { 
        label = "Kalifornine šilauoge",  
        price = 1.00,
        item = "Evergreen_Huckleberry",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Bay_Bolete"] = { 
        label = "Baravykas",  
        price = 1.00,
        item = "Bay_Bolete",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Red_Sage"] = { 
        label = "Raudonasis Šalavijas",  
        price = 1.00,
        item = "Red_Sage",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Wisteria"] = { 
        label = "Visterija",  
        price = 1.00,
        item = "Wisteria",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Blood_Flower"] = { 
        label = "Nuodingasis klemalis",  
        price = 1.00,
        item = "Blood_Flower",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Wintergreen_Berry"] = { 
        label = "Bruknes",  
        price = 1.00,
        item = "Wintergreen_Berry",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Cardinal_Flower"] = { 
        label = "Purpurine lobelija",  
        price = 1.00,
        item = "Cardinal_Flower",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Bulrush"] = { 
        label = "Švendras",  
        price = 1.00,
        item = "Bulrush",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["English_Mace"] = { 
        label = "Vaistinė kraujažolė",  
        price = 1.00,
        item = "English_Mace",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Wild_Rhubarb"] = { 
        label = "Laukinis rabarbaras",  
        price = 1.00,
        item = "Wild_Rhubarb",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Yarrow"] = { 
        label = "Paprastoji kraujažolė",  
        price = 1.00,
        item = "Yarrow",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Red_Raspberry"] = { 
        label = "Aviete",  
        price = 1.00,
        item = "Red_Raspberry",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Violet_Snowdrop"] = { 
        label = "Violetine snieguole",  
        price = 1.00,
        item = "Violet_Snowdrop",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Black_Berry"] = { 
        label = "Gervuoges",  
        price = 1.00,
        item = "Black_Berry",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Prairie_Poppy"] = { 
        label = "Prerijos aguona",  
        price = 1.00,
        item = "Prairie_Poppy",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Hummingbird_Sage"] = { 
        label = "Kolibrinis šalavijas",  
        price = 1.00,
        item = "Hummingbird_Sage",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Agarita"] = { 
        label = "Agarita",  
        price = 1.00,
        item = "Agarita",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Chanterelles"] = { 
        label = "Voveraite",  
        price = 1.00,
        item = "Chanterelles",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Oregano"] = { 
        label = "Raudonelis",  
        price = 1.00,
        item = "Oregano",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Creeking_Thyme"] = { 
        label = "Ciobrelis",  
        price = 1.00,
        item = "Creeking_Thyme",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Creekplum"] = { 
        label = "Upelio slyva",  
        price = 1.00,
        item = "Creekplum",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Alaskan_Ginseng"] = { 
        label = "Aliaskos ženšenis",  
        price = 1.00,
        item = "Alaskan_Ginseng",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },    
    ["Milk_Weed"] = { 
        label = "Klemalis",  
        price = 1.00,
        item = "Milk_Weed",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["Indian_Tobacco"] = { 
        label = "Indėniškas Tabakas",  
        price = 1.00,
        item = "Indian_Tobacco",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    -- -- Ginklai
    -- ["WEAPON_REPEATER_CARBINE"] = { 
    --     label = "Repeater Carbine",  
    --     price = 1000.00,
    --     item = "WEAPON_REPEATER_CARBINE",
    --     priceChange = { increase = 50.00, decrease = 25.00 }, 
    --     minPrice = 500.00,
    --     type = "weapon"
    -- },
    -- ["WEAPON_RIFLE_VARMINT"] = { 
    --     label = "Varmint Rifle",  
    --     price = 800.00,
    --     item = "WEAPON_RIFLE_VARMINT",
    --     priceChange = { increase = 40.00, decrease = 20.00 }, 
    --     minPrice = 400.00,
    --     type = "weapon"
    -- },
    -- ["WEAPON_REVOLVER_CATTLEMAN"] = { 
    --     label = "Cattleman Revolver",  
    --     price = 600.00,
    --     item = "WEAPON_REVOLVER_CATTLEMAN",
    --     priceChange = { increase = 30.00, decrease = 15.00 }, 
    --     minPrice = 300.00,
    --     type = "weapon"
    -- }
    ----------- Valentine Prekių Parduotuvės ----------
    ["canteen"] = { 
        label = "Gertuvė",  
        price = 2.50,
        item = "canteen",
        priceChange = { increase = 0.13, decrease = 0.06 }, 
        minPrice = 0.01
    },
    ["pen"] = { 
        label = "Rašiklis",  
        price = 0.25,
        item = "pen",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["notebook"] = { 
        label = "Užrašų Knygutė",  
        price = 0.25,
        item = "notebook",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["telegram"] = { 
        label = "Telegrama",  
        price = 0.25,
        item = "telegram",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01
    },
    ["hairpomade"] = { 
        label = "Plaukų Vaškas",  
        price = 2.50,
        item = "hairpomade",
        priceChange = { increase = 0.13, decrease = 0.06 }, 
        minPrice = 0.01
    },
    ["WEAPON_MELEE_LANTERN"] = { 
        label = "Liktarna",  
        price = 0.25,
        item = "WEAPON_MELEE_LANTERN",
        priceChange = { increase = 0.01, decrease = 0.01 }, 
        minPrice = 0.01,
        type = "weapon"
    },
    ["lumberaxe"] = { 
        label = "Kirvis",  
        price = 50.00,
        item = "lumberaxe",
        priceChange = { increase = 2.50, decrease = 1.25 }, 
        minPrice = 0.01
    },
    ["pickaxe2"] = { 
        label = "Kirtiklis",  
        price = 2.00,
        item = "pickaxe2",
        priceChange = { increase = 0.10, decrease = 0.05 }, 
        minPrice = 0.01
    },
    ["goldpan"] = { 
        label = "Sijoklis Auksui",  
        price = 100.00,
        item = "goldpan",
        priceChange = { increase = 5.00, decrease = 2.50 }, 
        minPrice = 0.01
    },
    ---- Ginklų parduotuvės ----------
    ["WEAPON_MELEE_KNIFE"] = {
        label = "Peilis",
        price = 21.00,
        item = "WEAPON_MELEE_KNIFE",
        priceChange = { increase = 1.00, decrease = 0.50 },
        minPrice = 0.01,
        type = "weapon"
    },
    ["WEAPON_LASSO"] = {
        label = "Lasas",
        price = 28.50,
        item = "WEAPON_LASSO",
        priceChange = { increase = 1.25, decrease = 0.63 },
        minPrice = 0.01,
        type = "weapon"
    },
    ["WEAPON_BOW"] = {
        label = "Paprastas Lankas",
        price = 20.00,
        item = "WEAPON_BOW",
        priceChange = { increase = 1.00, decrease = 0.50 },
        minPrice = 0.01,
        type = "weapon"
    },
    ["cleanshort"] = {
        label = "Ginklo Alyva",
        price = 3.00,
        item = "cleanshort",
        priceChange = { increase = 0.13, decrease = 0.06 },
        minPrice = 0.01
    },
    ["WEAPON_REVOLVER_CATTLEMAN"] = {
        label = "Cattleman revoleris",
        price = 31.00,
        item = "WEAPON_REVOLVER_CATTLEMAN",
        priceChange = { increase = 1.50, decrease = 0.75 },
        minPrice = 0.01,
        type = "weapon"
    },
    ["WEAPON_RIFLE_VARMINT"] = {
        label = "Varmint šautuvas",
        price = 72.00,
        item = "WEAPON_RIFLE_VARMINT",
        priceChange = { increase = 3.50, decrease = 1.75 },
        minPrice = 0.01,
        type = "weapon"
    },
    ["ammovarmint"] = {
        label = "Varmintojo Šautuvo Šoviniai",
        price = 1.00,
        item = "ammovarmint",
        priceChange = { increase = 0.05, decrease = 0.03 },
        minPrice = 0.01
    },
    ["ammorevolvernormal"] = {
        label = "Revolverio šoviniai",
        price = 1.00,
        item = "ammorevolvernormal",
        priceChange = { increase = 0.05, decrease = 0.03 },
        minPrice = 0.01
    },
    ["ammoriflenormal"] = {
        label = "Graižtvinio Šautuvo Šoviniai",
        price = 1.00,
        item = "ammoriflenormal",
        priceChange = { increase = 0.05, decrease = 0.03 },
        minPrice = 0.01
    },
    ["ammopistolnormal"] = {
        label = "Pistoleto Šoviniai",
        price = 1.00,
        item = "ammopistolnormal",
        priceChange = { increase = 0.05, decrease = 0.03 },
        minPrice = 0.01
    },
    ["ammoshotgunnormal"] = {
        label = "Šratinio Šautuvo Šoviniai",
        price = 1.00,
        item = "ammoshotgunnormal",
        priceChange = { increase = 0.05, decrease = 0.03 },
        minPrice = 0.01
    },
    ["ammorepeaternormal"] = {
        label = "Repeaterio Šoviniai",
        price = 1.00,
        item = "ammorepeaternormal",
        priceChange = { increase = 0.05, decrease = 0.03 },
        minPrice = 0.01
    },
    ["ammoarrowsmallgame"] = {
        label = "Nekokybiško Lanko Strėlės",
        price = 1.00,
        item = "ammoarrowsmallgame",
        priceChange = { increase = 0.05, decrease = 0.03 },
        minPrice = 0.01
    },

    -- Rūbų parduotuvės ----------
    ["hat"] = { label = "Skrybėlė", price = 7.29, item = "hat", priceChange = { increase = 0.36, decrease = 0.18 }, minPrice = 0.01 },
    ["shirt"] = { label = "Marškiniai", price = 3.94, item = "shirt", priceChange = { increase = 0.20, decrease = 0.10 }, minPrice = 0.01 },
    ["pants"] = { label = "Kelnės", price = 3.65, item = "pants", priceChange = { increase = 0.18, decrease = 0.09 }, minPrice = 0.01 },
    ["boots"] = { label = "Batai", price = 10.36, item = "boots", priceChange = { increase = 0.52, decrease = 0.26 }, minPrice = 0.01 },
    ["vest"] = { label = "Liemenė", price = 5.78, item = "vest", priceChange = { increase = 0.29, decrease = 0.14 }, minPrice = 0.01 },
    ["coat"] = { label = "Paltas", price = 8.12, item = "coat", priceChange = { increase = 0.41, decrease = 0.20 }, minPrice = 0.01 },
    ["glove"] = { label = "Pirštinės", price = 4.88, item = "glove", priceChange = { increase = 0.25, decrease = 0.12 }, minPrice = 0.01 },
    ["mask"] = { label = "Kaukė", price = 12.50, item = "mask", priceChange = { increase = 0.63, decrease = 0.31 }, minPrice = 0.01 },
    ["neckwear"] = { label = "Kaklo Apyrankė", price = 4.00, item = "neckwear", priceChange = { increase = 0.20, decrease = 0.10 }, minPrice = 0.01 },
    ["suspenders"] = { label = "Petnešos", price = 1.78, item = "suspenders", priceChange = { increase = 0.09, decrease = 0.05 }, minPrice = 0.01 },
    ["poncho"] = { label = "Pončas", price = 6.00, item = "poncho", priceChange = { increase = 0.30, decrease = 0.15 }, minPrice = 0.01 },
    ["cloak"] = { label = "Apsiaustas", price = 22.50, item = "cloak", priceChange = { increase = 1.13, decrease = 0.56 }, minPrice = 0.01 },
    ["bracelet"] = { label = "Apyrankė", price = 15.00, item = "bracelet", priceChange = { increase = 0.75, decrease = 0.38 }, minPrice = 0.01 },
    ["gunbelt"] = { label = "Ginklų Diržas", price = 75.00, item = "gunbelt", priceChange = { increase = 3.75, decrease = 1.88 }, minPrice = 0.01 },
    ["belt"] = { label = "Diržas", price = 12.50, item = "belt", priceChange = { increase = 0.63, decrease = 0.31 }, minPrice = 0.01 },
    ["buckle"] = { label = "Diržo Sagtis", price = 7.50, item = "buckle", priceChange = { increase = 0.38, decrease = 0.19 }, minPrice = 0.01 },
    ["holster"] = { label = "Ginklų Makštis", price = 10.00, item = "holster", priceChange = { increase = 0.50, decrease = 0.25 }, minPrice = 0.01 },
    ["chap"] = { label = "Šlauninės", price = 5.32, item = "chap", priceChange = { increase = 0.27, decrease = 0.13 }, minPrice = 0.01 },
    ["spur"] = { label = "Pentinai", price = 6.03, item = "spur", priceChange = { increase = 0.30, decrease = 0.15 }, minPrice = 0.01 },
    ["accessory"] = { label = "Aksesuaras", price = 1.50, item = "accessory", priceChange = { increase = 0.08, decrease = 0.04 }, minPrice = 0.01 },
    ["satchel"] = { label = "Kuprinė", price = 17.50, item = "satchel", priceChange = { increase = 0.88, decrease = 0.44 }, minPrice = 0.01 },
    ["gauntlet"] = { label = "Plieninės Pirštinės", price = 12.50, item = "gauntlet", priceChange = { increase = 0.63, decrease = 0.31 }, minPrice = 0.01 },
    ["eyewear"] = { label = "Akiniai", price = 6.00, item = "eyewear", priceChange = { increase = 0.30, decrease = 0.15 }, minPrice = 0.01 },
    ["armor"] = { label = "Šarvai", price = 35.00, item = "armor", priceChange = { increase = 1.75, decrease = 0.88 }, minPrice = 0.01 },
    ["spats"] = { label = "Kojinės", price = 2.50, item = "spats", priceChange = { increase = 0.13, decrease = 0.06 }, minPrice = 0.01 },
    ["jewelry_rings_left"] = { label = "Žiedas (Kairė)", price = 20.00, item = "jewelry_rings_left", priceChange = { increase = 1.00, decrease = 0.50 }, minPrice = 0.01 },
    ["jewelry_rings_right"] = { label = "Žiedas (Dešinė)", price = 20.00, item = "jewelry_rings_right", priceChange = { increase = 1.00, decrease = 0.50 }, minPrice = 0.01 },
    ["neckties"] = { label = "Kaklaraištis", price = 4.50, item = "neckties", priceChange = { increase = 0.23, decrease = 0.11 }, minPrice = 0.01 },
    ["loadouts"] = { label = "Įranga", price = 12.50, item = "loadouts", priceChange = { increase = 0.63, decrease = 0.31 }, minPrice = 0.01 },
    ["coats_closed"] = { label = "Uždarytas Paltas", price = 9.00, item = "coats_closed", priceChange = { increase = 0.45, decrease = 0.23 }, minPrice = 0.01 }
}



