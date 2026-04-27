local VorpCore = {}
local VorpInv = {}
local stockPrices = {} -- Ši lentelė laikys kainas su 2 skaitmenimis po kablelio (DB formatas)
local preciseStockPrices = {} -- Ši lentelė laikys kainas su didesniu tikslumu atmintyje
local cooldowns = {} --  cooldown for all players



local Core = exports.vorp_core:GetCore()


-- SQL užklausos
local SQL = {
    createTable = [[
        CREATE TABLE IF NOT EXISTS stocks (
            stock_id VARCHAR(50) PRIMARY KEY,
            price DECIMAL(10, 2) NOT NULL
        )
    ]],
    selectCount = "SELECT COUNT(*) FROM stocks WHERE stock_id = @stock_id",
    insertStock = "INSERT INTO stocks (stock_id, price) VALUES (@stock_id, @price)",
    selectAllCount = "SELECT COUNT(*) AS count FROM stocks",
    selectAllStocks = "SELECT stock_id, price FROM stocks",
    updatePrice = "UPDATE stocks SET price = @price WHERE stock_id = @id",
    -- Pridedamos naujos SQL užklausos mokesčių sekimui
    createTaxTable = [[
        CREATE TABLE IF NOT EXISTS collected_taxes (
            tax_id VARCHAR(50) PRIMARY KEY,
            collected_amount DECIMAL(15, 2) DEFAULT 0.00 NOT NULL
        )
    ]],
    ensureStockTaxRow = "INSERT IGNORE INTO collected_taxes (tax_id, collected_amount) VALUES ('stock_market_tax', 0.00)",
    addCollectedTax = "UPDATE collected_taxes SET collected_amount = collected_amount + @tax_amount WHERE tax_id = 'stock_market_tax'",
    getCollectedTax = "SELECT collected_amount FROM collected_taxes WHERE tax_id = 'stock_market_tax'"
}

-- Debug pranešimai
local DebugMessages = {
    checkingDegradation = "^2[DEBUG] Checking degradation for item:^7",
    totalItems = "^2[DEBUG] Total inventory items:^7",
    checkingItem = "^2[DEBUG] Checking item:^7",
    foundItem = "^2[DEBUG] Found matching item:^7",
    itemMetadata = "^2[DEBUG] Item metadata:^7",
    foundDegradation = "^2[DEBUG] Found degradation value:^7",
    usingPercentage = "^2[DEBUG] Using item percentage:^7",
    nonPerishableZeroPercent = "^2[DEBUG] Item with 0% is not perishable, using 100%^7",
    defaultDegradation = "^2[DEBUG] No degradation found, using default 100%^7"
}

-- Initialize translations
local Translations = {}

Citizen.CreateThread(function()
    local language = Config.Language or "en"
    Translations = Config.Translations[language] or Config.Translations["en"]
    -- print("Vertimai serverio pusėje įkelti:", json.encode(Translations))
end)


setmetatable(Translations, {
    __index = function(_, key)
        local language = Config.Language or "en"
        local translation = Config.Translations[language][key] or Config.Translations["en"][key]
        if not translation then
            print(string.format(Config.SystemMessages.noTranslation, key))
            return key -- Grąžins raktą kaip atsarginį vertimą
        end
        return translation
    end
})

TriggerEvent("getCore", function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()


-- Įterpiame trūkstamas funkcijas, perkeltos aukščiau, kad būtų pasiekiamos globaliai
local function round(value, decimals)
    local multiplier = 10^(decimals or 0)
    local rounded = math.floor(value * multiplier + 0.5) / multiplier    
    return rounded
end
local function calculateTax(totalCost)
    local rawTax = totalCost * (Config.Tax / 100)    
    return round(rawTax, 2)
end

-- Sukurkite lentelę, jei jos nėra, ir pridėkite trūkstamus įrašus
MySQL.ready(function()
    -- Lentelės kūrimas
    MySQL.Async.execute(SQL.createTable, {}, function(affectedRows)
        -- Po sėkmingo akcijų lentelės sukūrimo (arba jei ji jau egzistavo),
        -- kuriame mokesčių lentelę.
        MySQL.Async.execute(SQL.createTaxTable, {}, function(affectedRowsTax)
            -- Po sėkmingo mokesčių lentelės sukūrimo (arba jei ji jau egzistavo),
            -- užtikriname, kad yra pradinis mokesčių įrašas.
            MySQL.Async.execute(SQL.ensureStockTaxRow, {})
        end)
    end)

    -- Patikrinkite ir pridėkite trūkstamus įrašus į 'stocks' lentelę
    for stockId, stock in pairs(Config.Stocks) do
        MySQL.Async.fetchScalar(SQL.selectCount, {
            ['@stock_id'] = stockId
        }, function(count)
            if count == 0 then
                MySQL.Async.execute(SQL.insertStock, {
                    ['@stock_id'] = stockId,
                    ['@price'] = stock.price
                })
            end
        end)
    end
end)



-- Load initial data if the table was created
MySQL.ready(function()
    MySQL.Async.fetchAll(SQL.selectAllCount, {}, function(result)
        if result[1].count == 0 then
            for stockId, stock in pairs(Config.Stocks) do
                MySQL.Async.execute(SQL.insertStock, {
                    stock_id = stockId, price = stock.price
                })
            end
            print(Config.SystemMessages.initialDataLoaded)
        end
    end)
end)

-- Load prices from the database
MySQL.ready(function()
    MySQL.Async.fetchAll(SQL.selectAllStocks, {}, function(results)
        for _, row in pairs(results) do
            stockPrices[row.stock_id] = tonumber(row.price) -- Užtikrinam, kad tai skaičius
            preciseStockPrices[row.stock_id] = tonumber(row.price) -- Pradžioje tikslumas toks pat kaip DB
        end
    end)
end)

-- Debug Print funkcija: spausdina tik jei Config.Debug yra true
local function DebugPrint(...)
    if Config.Debug then
        print(...)
    end
end

-- Function to update prices for all clients
local function updatePricesForAll()
    local prices = {}
    if Config.Debug then DebugPrint("[STOCKMARKET_DEBUG] updatePricesForAll called (will update all clients).") end
    for stockId, stock in pairs(Config.Stocks) do
        local currentMarketPrice_PreTax = preciseStockPrices[stockId] or stock.price
        local taxForOneUnit = calculateTax(currentMarketPrice_PreTax) 
        
        local buyPriceForClientDisplay = round(currentMarketPrice_PreTax + taxForOneUnit, 2)
        local sellPriceForClientDisplay = round(math.max(stock.minPrice, currentMarketPrice_PreTax * (1 - stock.priceChange / 100)), 2)

        -- Nebereikia detalių logų čia kiekvienai akcijai
        -- if Config.Debug then
        --     DebugPrint("[STOCKMARKET_DEBUG]   StockID: " .. stockId)
        --     DebugPrint("[STOCKMARKET_DEBUG]     Raw precise price: " .. tostring(currentMarketPrice_PreTax))
        --     DebugPrint("[STOCKMARKET_DEBUG]     Tax for one unit: " .. tostring(taxForOneUnit))
        --     DebugPrint("[STOCKMARKET_DEBUG]     Buy Display: " .. tostring(buyPriceForClientDisplay))
        --     DebugPrint("[STOCKMARKET_DEBUG]     Sell Display: " .. tostring(sellPriceForClientDisplay))
        -- end

        prices[stockId] = { buy = buyPriceForClientDisplay, sell = sellPriceForClientDisplay }
    end    
    TriggerClientEvent('stockmarket:updatePrices', -1, prices)
end

-- Function to check cooldown
local function isOnCooldown(playerId)
    local currentTime = GetGameTimer()
    if cooldowns[playerId] and currentTime - cooldowns[playerId] < Config.cooldownTime * 1000 then
        return true, math.ceil((Config.cooldownTime * 1000 - (currentTime - cooldowns[playerId])) / 1000)
    end
    return false, 0
end

-- Function to update cooldown
local function setCooldown(playerId)
    cooldowns[playerId] = GetGameTimer()
end

-- Tikrina, ar lentelėje yra nurodyta reikšmė
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

--Discord hook
local function sendSummaryToDiscord()
    -- 1) Build groups of locations with identical stock sets
    local function canonicalKey(stocks)
        local copy = {}
        for _, s in ipairs(stocks) do table.insert(copy, s) end
        table.sort(copy)
        return table.concat(copy, ",")
    end

    local groups = {}
    for _, location in ipairs(Config.StockMarketLocations) do
        local key = canonicalKey(location.stocks)
        if not groups[key] then
            groups[key] = { names = {}, stocks = location.stocks }
        end
        table.insert(groups[key].names, location.name)
    end

    local embeds = {}
    local function pushEmbed(title, description)
        table.insert(embeds, { title = title, description = description, color = 0x00ff00 })
    end

    for _, group in pairs(groups) do
        -- Prepare common item lines
        local lines = {}
        for _, stockId in ipairs(group.stocks) do
            local stock = Config.Stocks[stockId]
            if stock then
                local preciseBuyPrice = preciseStockPrices[stockId] or stock.price
                local buyPrice = round(preciseBuyPrice, 2)
                local sellPrice = round(math.max(stock.minPrice, preciseBuyPrice * (1 - stock.priceChange / 100)), 2)
                table.insert(lines, string.format("%s: $%.2f | $%.2f", stock.label, buyPrice, sellPrice))
            end
        end
        if #lines == 0 then lines = { Config.DiscordMessages.noItems } end
        local description = table.concat(lines, "\n")

        -- Combine location names, ensure title length <= 256
        local titleBase = table.concat(group.names, " / ")
        if #titleBase <= 250 then
            pushEmbed(titleBase, description)
        else
            -- Split title names into multiple embeds to respect limit
            local currentTitle = ""
            for i, name in ipairs(group.names) do
                if #currentTitle + #name + 3 <= 250 then -- 3 for separator
                    if currentTitle == "" then currentTitle = name else currentTitle = currentTitle .. " / " .. name end
                else
                    pushEmbed(currentTitle, description)
                    currentTitle = name
                end
            end
            if currentTitle ~= "" then pushEmbed(currentTitle, description) end
        end
    end

    if not Config.discordWebhook or not Config.webhookUrl then return end
    local webhookUrl = Config.webhookUrl

    local index = 1
    while index <= #embeds do
        local chunk = {}
        for i = 0, 9 do if embeds[index + i] then table.insert(chunk, embeds[index + i]) end end
        local payload = { content = (index == 1) and Config.DiscordMessages.content or nil, embeds = chunk }
        local jsonPayload = json.encode(payload)
        DebugPrint("[STOCKMARKET_DEBUG] Sending grouped summary chunk to Discord ("..index.."/"..#embeds..")")
        PerformHttpRequest(webhookUrl, function(err, text, headers)
            if err and err ~= 204 then
                print(string.format("[Stock Market] Discord summary send failed. Error: %s, Response: %s", err, text))
            else
                DebugPrint("[Stock Market] Discord summary chunk sent successfully.")
            end
        end, 'POST', jsonPayload, { ['Content-Type'] = 'application/json' })
        index = index + 10
    end
end




-- Schedule periodic Discord updates
Citizen.CreateThread(function()
    while true do
        Wait(Config.DiscordUpdateInterval * 1000) -- Interval in seconds (convert to milliseconds)
        sendSummaryToDiscord()
    end
end)

-- Admin command to send a summary to Discord
RegisterCommand(Config.Discordwebhookmanualcommand, function(source, args)
    -- Check if the Discord sending feature is enabled
    if not Config.discordWebhook then
        print(Config.DiscordFormats.adminMessages.disabledFeature)
        return
    end
    if source == 0 then -- RCON
        print(Config.DiscordFormats.adminMessages.summarySent)
    else
        local user = Core.getUser(source)
        local userGroup = user.getGroup
        if userGroup == "admin" then
            sendSummaryToDiscord()
            TriggerClientEvent('vorp:TipBottom', source, Config.DiscordFormats.adminMessages.successMessage, 3000)
        else
            TriggerClientEvent('vorp:TipBottom', source, Config.DiscordFormats.adminMessages.unauthorizedMessage, 3000)
        end
    end
end, false)

-- Request event
RegisterServerEvent('stockmarket:requestPrices')
AddEventHandler('stockmarket:requestPrices', function()
    local _source = source
    local prices = {}
    for stockId, stock in pairs(Config.Stocks) do
        local currentMarketPrice_PreTax = stockPrices[stockId] or stock.price
        local taxForOneUnit = calculateTax(currentMarketPrice_PreTax) -- Apskaičiuojame mokestį vienam vienetui

        -- Pirkimo kaina klientui: rinkos kaina + mokestis už vieną vienetą
        local buyPriceForClientDisplay = currentMarketPrice_PreTax + taxForOneUnit
        -- Pardavimo kaina klientui: rinkos kaina sumažinta kainos pokyčiu (prieš mokesčius nuo pajamų ir degradaciją)
        local sellPriceForClientDisplay = math.max(stock.minPrice, currentMarketPrice_PreTax * (1 - stock.priceChange / 100))
        
        prices[stockId] = { buy = buyPriceForClientDisplay, sell = sellPriceForClientDisplay }
    end
    TriggerClientEvent('stockmarket:updatePrices', _source, prices)
end)

-- Purchase function
RegisterServerEvent('stockmarket:buyStock')
AddEventHandler('stockmarket:buyStock', function(stockId, amount, locationName)
    local _source = source

    -- General cooldown check
    local onCooldown, remainingTime = isOnCooldown(_source)
    if onCooldown then
        TriggerClientEvent('stockmarket:notify', _source, string.format(Translations.cooldownNotification, remainingTime), "error")
        return
    end

    setCooldown(_source)

    -- Patikriname, ar akcija leidžiama pasirinktoje lokacijoje
    local isStockValid = false
    for _, location in pairs(Config.StockMarketLocations) do
        if location.name == locationName and table.contains(location.stocks, stockId) then
            isStockValid = true
            break
        end
    end

    if not isStockValid then
        TriggerClientEvent('stockmarket:notify', _source, Translations.invalidStock, "error")
        return
    end

    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local playerMoney = Character.money

    local stock = Config.Stocks[stockId]
    -- Imam pradinę kainą iš tiksliosios lentelės
    local currentPrecisePrice = preciseStockPrices[stockId] or stock.price 
    local preciseTotalCost_PreTax = 0 

    -- Skaičiuojam bendrą kainą (prieš mokesčius) ir kainos pokytį su tiksliomis reikšmėmis
    for i = 1, amount do
        preciseTotalCost_PreTax = preciseTotalCost_PreTax + currentPrecisePrice
        currentPrecisePrice = currentPrecisePrice * (1 + stock.priceChange / 100) 
    end
        
    -- Nauja mokesčių ir galutinės kainos skaičiavimo logika
    local preciseTaxAmount = preciseTotalCost_PreTax * (Config.Tax / 100)
    local finalPrecisePlayerCost = preciseTotalCost_PreTax + preciseTaxAmount
    local finalPlayerCost_Rounded = round(finalPrecisePlayerCost, 2)

    -- Mokesčių suma, kuri bus įrašyta į DB (apvalinta)
    local taxAmountForDB = round(preciseTaxAmount, 2)

    DebugPrint("[STOCKMARKET_DEBUG] BUYING STOCK: " .. stockId)
    DebugPrint("[STOCKMARKET_DEBUG] Amount: " .. tostring(amount))
    DebugPrint("[STOCKMARKET_DEBUG] Initial preciseStockPrice for " .. stockId .. ": " .. tostring(preciseStockPrices[stockId] or stock.price))
    DebugPrint("[STOCKMARKET_DEBUG] preciseTotalCost_PreTax: " .. tostring(preciseTotalCost_PreTax))
    DebugPrint("[STOCKMARKET_DEBUG] preciseTaxAmount (calculated from preciseTotalCost_PreTax): " .. tostring(preciseTaxAmount))
    DebugPrint("[STOCKMARKET_DEBUG] finalPrecisePlayerCost (preTax + preciseTax): " .. tostring(finalPrecisePlayerCost))
    DebugPrint("[STOCKMARKET_DEBUG] finalPlayerCost_Rounded (to be paid by player): " .. tostring(finalPlayerCost_Rounded))
    DebugPrint("[STOCKMARKET_DEBUG] taxAmountForDB (to be collected): " .. tostring(taxAmountForDB))

    if playerMoney >= finalPlayerCost_Rounded then 
        -- Pridedame patikrinimą, ar žaidėjas gali panešti perkamą daiktą.
        -- Šis patikrinimas atliekamas TIK daiktams, kurie nėra ginklai, nes ginklai gali tureti kitokius inventory limitus.
        -- Check if the player can carry the item.
        -- This check is performed ONLY for items that are not weapons, as weapons might have different inventory limits.
        if stock.type ~= "weapon" then
            if not VorpInv.canCarryItem(_source, stock.item, amount) then
                -- Jei žaidėjas negali panešti daikto (ne ginklo)
                -- If the player cannot carry the item (non-weapon)
                TriggerClientEvent('stockmarket:notify', _source, Translations.cannotCarryItem, "error")
                return -- Atšaukiame pirkimą
            end
        end

        Character.removeCurrency(0, finalPlayerCost_Rounded)
        
        preciseStockPrices[stockId] = currentPrecisePrice 
        stockPrices[stockId] = round(currentPrecisePrice, 2) 
        
        MySQL.Async.execute(SQL.updatePrice, {
            ['@price'] = stockPrices[stockId], 
            ['@id'] = stockId
        })

        if taxAmountForDB > 0 then
            MySQL.Async.execute(SQL.addCollectedTax, {
                ['@tax_amount'] = taxAmountForDB
            })
        end

        if stock.type == "weapon" then
            -- Ginklams nenaudojame VorpInv.addItem, o registruojame ginklą
            -- For weapons, we don't use VorpInv.addItem, but register the weapon
            TriggerEvent("vorpCore:registerWeapon", _source, stock.item)
        else
            -- Kitiems daiktams naudojame VorpInv.addItem
            -- For other items, use VorpInv.addItem
            VorpInv.addItem(_source, stock.item, amount)
        end
        
        -- Siunčiame pranešimą apie sėkmingą pirkimą
        TriggerClientEvent('stockmarket:notify', _source, string.format(Translations.buySuccess, amount, stock.label, finalPlayerCost_Rounded), "success")

        DebugPrint("[STOCKMARKET_DEBUG] BUY TRANSACTION END for " .. stockId .. ". Player paid: " .. tostring(finalPlayerCost_Rounded))

        -- Iškart išsiunčiame atnaujintas kainas šiam klientui
        local singleClientPrices = {}
        -- Ruošiame kainas VISOMS akcijoms šiam klientui, bet log'insim tik tą, kuri buvo pirkta/parduota
        for sId, sInfo in pairs(Config.Stocks) do
            local currentMarketPrice_PreTax_single = preciseStockPrices[sId] or sInfo.price
            local taxForOneUnit_single = calculateTax(currentMarketPrice_PreTax_single)
            
            local buyPriceForClientDisplay_single = round(currentMarketPrice_PreTax_single + taxForOneUnit_single, 2)
            local sellPriceForClientDisplay_single = round(math.max(sInfo.minPrice, currentMarketPrice_PreTax_single * (1 - sInfo.priceChange / 100)), 2)
            
            if sId == stockId and Config.Debug then -- Log'inam TIK AKCIJĄ, SU KURIA VYKO SANDORIS
                DebugPrint("[STOCKMARKET_DEBUG] POST-BUY UPDATE_PRICES for interacted stock "..sId.." (for initiating client)")
                DebugPrint("[STOCKMARKET_DEBUG]   Precise price AFTER buy: "..tostring(currentMarketPrice_PreTax_single))
                DebugPrint("[STOCKMARKET_DEBUG]   Tax for one unit (based on new precise price): "..tostring(taxForOneUnit_single))
                DebugPrint("[STOCKMARKET_DEBUG]   New Buy Display Price: "..tostring(buyPriceForClientDisplay_single)) 
                DebugPrint("[STOCKMARKET_DEBUG]   New Sell Display Price: "..tostring(sellPriceForClientDisplay_single))
            end

            singleClientPrices[sId] = { buy = buyPriceForClientDisplay_single, sell = sellPriceForClientDisplay_single }
        end
        TriggerClientEvent('stockmarket:updatePrices', _source, singleClientPrices)
        
        updatePricesForAll()
    else
        TriggerClientEvent('stockmarket:notify', _source, Translations.notEnoughMoney, "error")
    end
end)

-- Funkcija gauti daikto maksimalią degradaciją
local function GetItemMaxDegradation(itemName)
    if Config.ExpirationRules then
        for _, rule in pairs(Config.ExpirationRules) do
            if rule.itemName == itemName then
                return rule.defaultDegradationTime
            end
        end
    end
    return nil
end

-- Funkcija gauti daikto degradaciją iš VORP inventory
local function GetItemDegradation(itemName, source, callback)
    local items = VorpInv.getUserInventory(source)
    DebugPrint(DebugMessages.checkingDegradation, itemName)
    
    for _, item in pairs(items) do
        if item.name == itemName then
            DebugPrint(DebugMessages.foundItem, itemName)
            local metadata = item.metadata
            
            if metadata then
                local explicitDegradationValue = metadata.durability or metadata.condition or metadata.degradation
                if explicitDegradationValue ~= nil then
                    DebugPrint(string.format("^2[DEBUG] Found explicit degradation in metadata for %s: %s^7", itemName, tostring(explicitDegradationValue)))
                    callback(tonumber(explicitDegradationValue))
                    return
                end
                if metadata.percentage ~= nil then
                    DebugPrint(string.format("^2[DEBUG] Found percentage in metadata for %s: %s^7", itemName, tostring(metadata.percentage)))
                    callback(tonumber(metadata.percentage)) -- Jei 0, tai 0
                    return
                end
            end
            
            if item.percentage ~= nil then
                local percentage = tonumber(item.percentage)
                DebugPrint(string.format("^2[DEBUG] Found item.percentage for %s: %s^7", itemName, tostring(percentage)))
                
                if percentage == 0 then
                    local isPerishable = false
                    if Config.ExpirationRules then
                        for _, rule in pairs(Config.ExpirationRules) do
                            if rule.itemName == itemName then
                                isPerishable = true
                                break
                            end
                        end
                    end

                    if isPerishable then
                        -- Daiktas yra gendamas/dėvimas IR jo būklė 0%
                        DebugPrint(string.format("^2[DEBUG] Item %s is perishable (has ExpirationRule) and at 0%%, using 0%% for price calculation.^7", itemName))
                        callback(0)
                    else
                        -- Daiktas NĖRA gendamas/dėvimas (pagal ExpirationRules) IR jo būklė 0%
                        -- Tai tikriausiai numatytoji reikšmė daiktui be būklės. Naudojam 100%.
                        DebugPrint(string.format("^2[DEBUG] Item %s is NOT perishable (no ExpirationRule) and item.percentage is 0%%, assuming 100%% for price calculation.^7", itemName))
                    callback(100)
                    end
                    return
                else -- item.percentage yra ne nil ir ne 0
                    callback(percentage)
                    return
                end
            end
            
            -- Jei pasiekėme čia: item.name sutapo, bet NEBUVO metadata su būkle IR NEBUVO item.percentage.
            -- Tai yra tikras "daiktas be būklės duomenų".
            DebugPrint(string.format("^2[DEBUG] No degradation data (metadata/item.percentage was nil) found for matched item %s. Using default 100%%.^7", itemName))
            callback(100)
                return
        end
    end
    
    -- Jei neradome daikto su tokiu pavadinimu inventoriuje.
    DebugPrint(string.format("^2[DEBUG] Item %s not found in inventory. Using default 100%% for degradation (implies item doesn't exist for sale).^7", itemName))
    callback(100) -- Jei daikto nėra, tai nėra ir jo būklės.
end

-- Kainos skaičiavimo funkcija su decay
local function CalculatePriceWithDecay(basePrice, currentDegradation)
    -- Jei daikto būklė yra 0%, parduodame už 0 kainą
    if currentDegradation == 0 then
        return 0
    end

    -- Jei daikto būklė viršija arba lygi tolerancijos ribai - pilna kaina
    if currentDegradation >= Config.DecayTolerance then
        return basePrice
    end
    
    -- Degradation yra procentais (0-100)
    local condition = currentDegradation / 100
    -- Apribojame condition tarp 0.0 ir 1.0 (0% - 100% originalios kainos)
    condition = math.max(0.0, math.min(1.0, condition)) -- Pakeista 0.1 į 0.0
    return basePrice * condition
end

-- Funkcija siųsti pranešimą į Discord
local function sendToDiscord(title, description, color, isTransaction)
    if Config.discordWebhook then
        local embed = {
            {
                ["title"] = title,
                ["description"] = description,
                ["color"] = color or 16776960,
                ["footer"] = {
                    ["text"] = os.date("%Y-%m-%d %H:%M:%S")
                }
            }
        }
        
        -- Pasirenkame webhook URL pagal tipą
        local webhookUrl = isTransaction and Config.transactionWebhookUrl or Config.webhookUrl
        
        if webhookUrl then
            PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
        end
    end
end

-- Pardavimo funkcija
RegisterServerEvent('stockmarket:sellStock')
AddEventHandler('stockmarket:sellStock', function(stockId, amount, locationName)
    local _source = source

    local onCooldown, remainingTime = isOnCooldown(_source)
    if onCooldown then
        TriggerClientEvent('stockmarket:notify', _source, string.format(Translations.cooldownNotification, remainingTime), "error")
        return
    end

    setCooldown(_source)

    local isStockValid = false
    for _, location in pairs(Config.StockMarketLocations) do
        if location.name == locationName and table.contains(location.stocks, stockId) then
            isStockValid = true
            break
        end
    end

    if not isStockValid then
        TriggerClientEvent('stockmarket:notify', _source, Translations.invalidStock, "error")
        return
    end

    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local stock = Config.Stocks[stockId]

    -- Nustatome dabartinę rinkos kainą (tai yra pirkimo kaina) iš tiksliosios lentelės
    local actualPreciseMarketPrice = preciseStockPrices[stockId] or stock.price 

    -- Nustatome efektyvią pardavimo kainą už vienetą, kurią žaidėjas turėtų gauti (iš tikslios rinkos kainos)
    local effectivePreciseSellPricePerUnit = math.max(stock.minPrice, actualPreciseMarketPrice * (1 - stock.priceChange / 100))

    -- Ginklų logika
    if stock.type == "weapon" then
        exports.vorp_inventory:getUserInventoryWeapons(_source, function(weapons)
            local weaponId = nil
            for _, weapon in pairs(weapons) do
                if weapon.name == stock.item then
                    weaponId = weapon.id
                    break
                end
            end
            if not weaponId then
                TriggerClientEvent('stockmarket:notify', _source, Translations.notEnoughItems, "error")
                return
            end

            exports.vorp_inventory:subWeapon(_source, weaponId, function(success)
                if success then
                    -- Weapons do not use degradation. Compute per-unit decreasing price and apply tax to the total.
                    local iterPrice = actualPreciseMarketPrice
                    local grossEarnings = 0
                    for i = 1, amount do
                        local perUnitSell = math.max(stock.minPrice, iterPrice * (1 - stock.priceChange / 100))
                        grossEarnings = grossEarnings + perUnitSell
                        iterPrice = math.max(stock.minPrice, iterPrice * (1 - stock.priceChange / 100))
                    end
                    local taxAmountForDiscordAndAccounting = calculateTax(grossEarnings)
                    local finalEarnings = round(grossEarnings - taxAmountForDiscordAndAccounting, 2)

                    Character.addCurrency(0, finalEarnings)

                    -- Record collected tax from sale
                    if taxAmountForDiscordAndAccounting > 0 then
                        MySQL.Async.execute(SQL.addCollectedTax, { ['@tax_amount'] = taxAmountForDiscordAndAccounting })
                    end

                    -- Rinkos kaina atnaujinama remiantis 'actualPreciseMarketPrice' (kaina prieš šį sandorį)
                    -- Kaina mažėja kiekvienam vienetui atskirai, o ne proporcingai kiekio
                    local newPreciseMarketPrice_PreTax = actualPreciseMarketPrice
                    for i = 1, amount do
                        newPreciseMarketPrice_PreTax = math.max(stock.minPrice, newPreciseMarketPrice_PreTax * (1 - stock.priceChange / 100))
                    end
                    preciseStockPrices[stockId] = newPreciseMarketPrice_PreTax -- Išsaugom naują tikslią kainą
                    stockPrices[stockId] = round(newPreciseMarketPrice_PreTax, 2) -- Atnaujinam apvalintą DB/stockPrices
                    
                    MySQL.Async.execute(SQL.updatePrice, {
                        ['@price'] = stockPrices[stockId], -- Į DB siunčiame jau suapvalintą kainą
                        ['@id'] = stockId
                    })

                    -- Siunčiame pranešimą apie sėkmingą pardavimą
                    TriggerClientEvent('stockmarket:notify', _source, string.format(Translations.sellSuccess, amount, stock.label, finalEarnings), "success")

                    DebugPrint("[STOCKMARKET_DEBUG] SELL TRANSACTION END for " .. stockId .. ". Player received: " .. tostring(finalEarnings))

                    -- Iškart išsiunčiame atnaujintas kainas šiam klientui
                    local singleClientPrices_w = {}
                    for sId_w, sInfo_w in pairs(Config.Stocks) do
                        local currentMarketPrice_PreTax_w = preciseStockPrices[sId_w] or sInfo_w.price
                        local taxForOneUnit_w = calculateTax(currentMarketPrice_PreTax_w)
                        local buyPriceForClientDisplay_w = round(currentMarketPrice_PreTax_w + taxForOneUnit_w, 2)
                        local sellPriceForClientDisplay_w = round(math.max(sInfo_w.minPrice, currentMarketPrice_PreTax_w * (1 - sInfo_w.priceChange / 100)),2)
                        
                        if sId_w == stockId and Config.Debug then -- Log'inam TIK AKCIJĄ, SU KURIA VYKO SANDORIS
                            DebugPrint("[STOCKMARKET_DEBUG] POST-SELL (weapon) UPDATE_PRICES for interacted stock "..sId_w.." (for initiating client)")
                            DebugPrint("[STOCKMARKET_DEBUG]   Precise price AFTER sell: "..tostring(currentMarketPrice_PreTax_w))
                            DebugPrint("[STOCKMARKET_DEBUG]   Tax for one unit (based on new precise price): "..tostring(taxForOneUnit_w))                            
                            DebugPrint("[STOCKMARKET_DEBUG]   New Buy Display Price: "..tostring(buyPriceForClientDisplay_w)) 
                            DebugPrint("[STOCKMARKET_DEBUG]   New Sell Display Price: "..tostring(sellPriceForClientDisplay_w))
                        end
                        singleClientPrices_w[sId_w] = { buy = buyPriceForClientDisplay_w, sell = sellPriceForClientDisplay_w }
                    end
                    TriggerClientEvent('stockmarket:updatePrices', _source, singleClientPrices_w)

                    local description = string.format(
                        Config.DiscordFormats.saleDescription,
                        amount,
                        stock.label,
                        finalEarnings, -- Net after tax
                        round(grossEarnings, 2), -- Base gross before tax
                        round(taxAmountForDiscordAndAccounting, 2), -- Tax withheld
                        locationName
                    )
                    sendToDiscord(Config.DiscordFormats.saleTitle, description, Config.DiscordFormats.saleColor, true)

                    updatePricesForAll()
                else
                    TriggerClientEvent('stockmarket:notify', _source, Translations.failedToRemoveWeapon, "error")
                end
            end)
        end)
        return
    else
        if VorpInv.getItemCount(_source, stock.item) < amount then
            TriggerClientEvent('stockmarket:notify', _source, Translations.notEnoughItems, "error")
            return
        end
    end

    -- Bendroji logika daiktams (įskaitant tuos su degradacija)
    GetItemDegradation(stock.item, _source, function(currentDegradation)
        -- Sum gross per unit with decreasing price and apply decay per unit
        local iterPrice = actualPreciseMarketPrice
        local grossEarnings = 0
        for i = 1, amount do
            local perUnitBase = math.max(stock.minPrice, iterPrice * (1 - stock.priceChange / 100))
            local perUnitWithDecay = CalculatePriceWithDecay(perUnitBase, currentDegradation)
            grossEarnings = grossEarnings + perUnitWithDecay
            iterPrice = math.max(stock.minPrice, iterPrice * (1 - stock.priceChange / 100))
        end
        local taxAmountForDiscordAndAccounting = calculateTax(grossEarnings)
        local finalEarnings = round(grossEarnings - taxAmountForDiscordAndAccounting, 2)

        -- Ginklų logika (buvo anksčiau, dabar bendras daiktų tvarkymas)
        -- Reikia užtikrinti, kad daiktas būtų pašalintas
        if stock.type == "weapon" then -- Šis blokas neturėtų būti pasiektas, jei ginklai tvarkomi aukščiau
            -- exports.vorp_inventory:subWeapon... (jau įvykdyta)
        else
            VorpInv.subItem(_source, stock.item, amount)
        end

        Character.addCurrency(0, finalEarnings)
        
        -- Record collected tax from sale
        if taxAmountForDiscordAndAccounting > 0 then
            MySQL.Async.execute(SQL.addCollectedTax, { ['@tax_amount'] = taxAmountForDiscordAndAccounting })
        end

        -- Rinkos kaina atnaujinama remiantis 'actualPreciseMarketPrice' (kaina prieš šį sandorį)
        -- Kaina mažėja kiekvienam vienetui atskirai, o ne proporcingai kiekio
        local newPreciseMarketPrice_PreTax = actualPreciseMarketPrice
        for i = 1, amount do
            newPreciseMarketPrice_PreTax = math.max(stock.minPrice, newPreciseMarketPrice_PreTax * (1 - stock.priceChange / 100))
        end
        preciseStockPrices[stockId] = newPreciseMarketPrice_PreTax -- Išsaugom naują tikslią kainą
        stockPrices[stockId] = round(newPreciseMarketPrice_PreTax, 2) -- Atnaujinam apvalintą DB/stockPrices
        
        MySQL.Async.execute(SQL.updatePrice, {
            ['@price'] = stockPrices[stockId], -- Į DB siunčiame jau suapvalintą kainą
            ['@id'] = stockId
        })

        -- Siunčiame pranešimą apie sėkmingą pardavimą su būklės informacija
        if currentDegradation < Config.DecayTolerance and currentDegradation < 100 then
            TriggerClientEvent('stockmarket:notify', _source, string.format(Translations.sellSuccessWithCondition, amount, stock.label, currentDegradation, finalEarnings), "success")
        else
            TriggerClientEvent('stockmarket:notify', _source, string.format(Translations.sellSuccess, amount, stock.label, finalEarnings), "success")
        end

        DebugPrint("[STOCKMARKET_DEBUG] SELL TRANSACTION END for " .. stockId .. " (item). Player received: " .. tostring(finalEarnings))

        -- Iškart išsiunčiame atnaujintas kainas šiam klientui
        local singleClientPrices_item = {}
        for sId_item, sInfo_item in pairs(Config.Stocks) do
            local currentMarketPrice_PreTax_item = preciseStockPrices[sId_item] or sInfo_item.price
            local taxForOneUnit_item = calculateTax(currentMarketPrice_PreTax_item)
            local buyPriceForClientDisplay_item = round(currentMarketPrice_PreTax_item + taxForOneUnit_item, 2)
            local sellPriceForClientDisplay_item = round(math.max(sInfo_item.minPrice, currentMarketPrice_PreTax_item * (1 - sInfo_item.priceChange / 100)), 2)

            if sId_item == stockId and Config.Debug then -- Log'inam TIK AKCIJĄ, SU KURIA VYKO SANDORIS
                DebugPrint("[STOCKMARKET_DEBUG] POST-SELL (item) UPDATE_PRICES for interacted stock "..sId_item.." (for initiating client)")
                DebugPrint("[STOCKMARKET_DEBUG]   Precise price AFTER sell: "..tostring(currentMarketPrice_PreTax_item))
                DebugPrint("[STOCKMARKET_DEBUG]   Tax for one unit (based on new precise price): "..tostring(taxForOneUnit_item))
                DebugPrint("[STOCKMARKET_DEBUG]   New Buy Display Price: "..tostring(buyPriceForClientDisplay_item)) 
                DebugPrint("[STOCKMARKET_DEBUG]   New Sell Display Price: "..tostring(sellPriceForClientDisplay_item))
            end

            singleClientPrices_item[sId_item] = { buy = buyPriceForClientDisplay_item, sell = sellPriceForClientDisplay_item }
        end
        TriggerClientEvent('stockmarket:updatePrices', _source, singleClientPrices_item)

        local description = string.format(
            Config.DiscordFormats.saleWithConditionDescription,
            amount,
            stock.label,
            finalEarnings, -- Net after tax
            round(grossEarnings, 2), -- Base gross before tax
            round(taxAmountForDiscordAndAccounting, 2), -- Tax withheld
            currentDegradation,
            locationName
        )
        sendToDiscord(Config.DiscordFormats.saleTitle, description, Config.DiscordFormats.saleColor, true)

        updatePricesForAll()
    end)
end)

-- Admino komanda patikrinti surinktus mokesčius
RegisterCommand(Config.AdminCommands and Config.AdminCommands.CheckStockTaxCommand or "checkstocktax", function(source, args, rawCommand)
    local user = VorpCore.getUser(source)
    if source == 0 or (user and user.getGroup == "admin") then -- Leidžiama RCON arba admin grupės nariams
        MySQL.Async.fetchScalar(SQL.getCollectedTax, {}, function(totalTax)
            local currentTotalTax = totalTax or 0.00
            local message = string.format(Translations.totalTaxCollectedMessage or "Bendra surinkta akcijų rinkos mokesčių suma: $%.2f", currentTotalTax)
            
            if source == 0 then
                print(message) -- RCON atveju spausdiname į konsolę
            else
                TriggerClientEvent('vorp:TipBottom', source, message, 7000) -- Kliento atveju rodome pranešimą
            end
        end)
    else
        TriggerClientEvent('vorp:TipBottom', source, Translations.notAuthorized or "Neturite teisių šiai komandai.", 4000)
    end
end, false) -- false reiškia, kad komanda nėra ribojama (ACE permission check atliekamas rankiniu būdu)

-- Bendra skaičiavimo funkcija, naudojama ir preview, ir tikram veiksmui
local function calculateStockTransaction(stockId, amount, action, source, isPreview, callback)
    local stock = Config.Stocks[stockId]
    if not stock or not amount or amount < 1 then
        callback({ success = false, total = 0, reason = 'invalid_params' })
        return
    end
    if action == 'buy' then
        local currentPrecisePrice = preciseStockPrices[stockId] or stock.price
        local preciseTotalCost_PreTax = 0
        for i = 1, amount do
            preciseTotalCost_PreTax = preciseTotalCost_PreTax + currentPrecisePrice
            currentPrecisePrice = currentPrecisePrice * (1 + stock.priceChange / 100)
        end
        local preciseTaxAmount = preciseTotalCost_PreTax * (Config.Tax / 100)
        local finalPrecisePlayerCost = preciseTotalCost_PreTax + preciseTaxAmount
        local finalPlayerCost_Rounded = round(finalPrecisePlayerCost, 2)
        local priceDescription = string.format(
            "Suma prieš mokesčius: $%.10f\nMokesčiai: $%.10f\nIš viso: $%.2f",
            preciseTotalCost_PreTax,
            preciseTaxAmount,
            finalPlayerCost_Rounded
        )
        if isPreview then
            print("[DEBUG][PREVIEW] BUY: total="..tostring(finalPlayerCost_Rounded)..", desc="..priceDescription)
        end
        callback({
            success = true,
            total = finalPlayerCost_Rounded,
            action = 'buy',
            priceDescription = priceDescription
        })
    elseif action == 'sell' then
        local actualPreciseMarketPrice = preciseStockPrices[stockId] or stock.price
        local effectivePreciseSellPricePerUnit = math.max(stock.minPrice, actualPreciseMarketPrice * (1 - stock.priceChange / 100))
        local function handleSellWithDecay(currentDegradation)
            local iterPrice = preciseStockPrices[stockId] or stock.price
            local gross = 0
            for i = 1, amount do
                local perUnitBase = math.max(stock.minPrice, iterPrice * (1 - stock.priceChange / 100))
                local perUnitWithDecay = CalculatePriceWithDecay(perUnitBase, currentDegradation or 100)
                gross = gross + perUnitWithDecay
                iterPrice = math.max(stock.minPrice, iterPrice * (1 - stock.priceChange / 100))
            end
            local tax = calculateTax(gross)
            local total = round(gross - tax, 2)
            local priceDescription = string.format("Gross: $%.2f\nTax: $%.2f\nNet: $%.2f", round(gross,2), round(tax,2), total)
            if isPreview then
                print("[DEBUG][PREVIEW] SELL: total="..tostring(total)..", desc="..priceDescription)
            end
            callback({
                success = true,
                total = total,
                action = 'sell',
                priceDescription = priceDescription
            })
        end
        if GetItemDegradation then
            GetItemDegradation(stock.item, source, function(currentDegradation)
                handleSellWithDecay(currentDegradation)
            end)
        else
            handleSellWithDecay(100)
        end
    else
        callback({ success = false, total = 0, reason = 'invalid_action' })
    end
end

RegisterServerEvent('stockmarket:calculateTotal')
AddEventHandler('stockmarket:calculateTotal', function(stockId, amount, action, locationName)
    local _source = source
    local stock = Config.Stocks[stockId]
    if not stock or not amount or amount < 1 then
        TriggerClientEvent('stockmarket:calculatedTotal', _source, { success = false, total = 0, reason = 'invalid_params' })
        return
    end
    -- Tik minimali validacija: ar leidžiama šioje lokacijoje
    local isStockValid = false
    for _, location in pairs(Config.StockMarketLocations) do
        if location.name == locationName and table.contains(location.stocks, stockId) then
            isStockValid = true
            break
        end
    end
    if not isStockValid then
        TriggerClientEvent('stockmarket:calculatedTotal', _source, { success = false, total = 0, reason = 'invalid_location' })
        return
    end
    calculateStockTransaction(stockId, amount, action, _source, true, function(result)
        TriggerClientEvent('stockmarket:calculatedTotal', _source, result)
    end)
end)



