local currentStockPrices = {}
local MenuData = {}
local blips = {} -- Table to store PERMANENT blips created at script start
local VORPcore = {}
local Translations = {}

-- GLOBAL VARIABLE FOR MENU OBJECT
CurrentStockActionMenu = nil

-- Debug Print function: prints only if Config.Debug is true
local function DebugPrint(...)
    if Config.Debug then
        print("[STOCKMARKET_CLIENT_DEBUG]", ...)
    end
end

local joaat = GetHashKey

-- Or define it as a global function
joaat = GetHashKey

-- VORP Core and Menu API initialization
TriggerEvent("getCore", function(core)
    VORPcore = core
end)

-- Menu API
TriggerEvent("menuapi:getData", function(call)
    MenuData = call
end)

-- Translations
Citizen.CreateThread(function()
    local language = Config.Language or "en"
    Translations = Config.Translations[language] or Config.Translations["en"]
end)

setmetatable(Translations, {
    __index = function(_, key)
        local language = Config.Language or "en"
        local translation = Config.Translations[language][key] or Config.Translations["en"][key]
        if not translation then
            DebugPrint(string.format("No translations for '%s' .", key))
            return key
        end
        return translation
    end
})

-- Notification system
RegisterNetEvent('stockmarket:notify')
AddEventHandler('stockmarket:notify', function(message, messageType)
    -- Split message into lines
    local lines = {}
    for line in message:gmatch("[^\n]+") do
        table.insert(lines, line)
    end

    -- Show each line separately with longer duration for success messages
    for i, line in ipairs(lines) do
        if messageType == "success" then
            -- Success messages show longer and use TipBottom for better visibility
            TriggerEvent("vorp:TipRight", line, 6000 + (i * 1000))
        elseif messageType == "error" then
            -- Error messages show on right side
            TriggerEvent("vorp:TipRight", line, 4000 + (i * 1000))
        else
            -- Default messages show on right side
            TriggerEvent("vorp:TipRight", line, 4000 + (i * 1000))
        end
    end
    
    -- Debug log for notifications
    if Config.Debug then
        DebugPrint("[NOTIFICATION] Type: " .. messageType .. ", Message: " .. message)
    end
end)

-- === PREVIEW STATE VARIABLES ===
local previewState = {
    open = false,
    stockId = nil,
    locationName = nil,
    amount = 0,
    lastTotal = 0,
    lastUpdateWasFromPriceChange = false
}

-- Reset previewState when menu is closed
local function resetPreviewState()
    previewState.open = false
    previewState.stockId = nil
    previewState.locationName = nil
    previewState.amount = 0
    -- Do NOT clear lastTotal or lastPriceDescription here; let fallback logic handle it
end

-- Event handler for price updates
RegisterNetEvent('stockmarket:updatePrices')
AddEventHandler('stockmarket:updatePrices', function(prices)
    currentStockPrices = prices

    if MenuData and MenuData.GetOpened and MenuData.GetOpened('stock_action_menu') then
        local menu = MenuData.GetOpened('stock_action_menu')
        if menu and menu.data and menu.data.elements then
            local stockId = previewState.stockId
            local stock = Config.Stocks[stockId]
            local maxQty = 100
            if stock and stock.item then
                local itemCount = exports.vorp_inventory:getItemCount(stock.item)
                maxQty = itemCount
            end

            menu.setElement(2, 'max', 100) -- Allow buying up to 100
            menu.setElement(2, 'disabled', false)
            menu.setElement(2, 'desc', Translations.buyQuantity)

            menu.setElement(3, 'max', maxQty) -- Allow selling up to the amount they have
            menu.setElement(3, 'disabled', false)
            menu.setElement(3, 'desc', Translations.sellQuantity)

            menu.refresh()
        end
    end

    if previewState.open and previewState.amount > 0 and previewState.stockId then
        previewState.lastUpdateWasFromPriceChange = true
        TriggerServerEvent('stockmarket:calculateTotal', previewState.stockId, previewState.amount,
            previewState.locationName)
    end
end)

-- Event handler updates amountBuy or amountSell based on server response
RegisterNetEvent('stockmarket:calculatedTotal')
AddEventHandler('stockmarket:calculatedTotal', function(data)
    local menuOpen = CurrentStockActionMenu
    DebugPrint("[calculatedTotal] Received response from server:", json.encode(data), "CurrentStockActionMenu:", tostring(menuOpen))
    DebugPrint("[calculatedTotal] data.action:", data.action, "data.total:", data.total)
    if menuOpen and menuOpen.setElement then
        if data.action == "buy" then
            amountBuy = data.total
            DebugPrint("[calculatedTotal] Setting amountBuy to:", amountBuy)
            menuOpen.setElement(2, 'descPrice', { amount = amountBuy, icon = 'money', text = Translations.buyText })
            menuOpen.setElement(4, 'descPrice', { amount = amountBuy, icon = 'money', text = Translations.total })
        elseif data.action == "sell" then
            amountSell = data.total
            DebugPrint("[calculatedTotal] Setting amountSell to:", amountSell)
            menuOpen.setElement(3, 'descPrice', { amount = amountSell, icon = 'money', text = Translations.sellText })
            menuOpen.setElement(4, 'descPrice', { amount = amountSell, icon = 'money', text = Translations.total })
        end
        menuOpen.refresh()
    else
        DebugPrint("[calculatedTotal] CurrentStockActionMenu is nil or doesn't have setElement!")
    end
end)

-- Function to freeze player
local function freezePlayer(toggle)
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, toggle)
    SetEntityInvincible(playerPed, toggle)
    SetPlayerInvincible(PlayerId(), toggle)
    if toggle then
        SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
        ClearPedTasks(playerPed)
    end
end

local function requestPricesFromServer()
    TriggerServerEvent('stockmarket:requestPrices')
end

-- Function to display 3D text
local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFontForCurrentCommand(1)
        SetTextColor(255, 255, 255, 215)
        SetTextCentre(1)
        DisplayText(CreateVarString(10, "LITERAL_STRING", text), _x, _y)
    end
end

-- Function to get distance
local function getDistance(config)
    local coords = GetEntityCoords(PlayerPedId())
    local coords2 = vector3(config.x, config.y, config.z)
    return #(coords - coords2)
end

-- MODIFIED Function to display prices from the current table, using a passed location
local function displayPromptWithPrices(currentLocation) -- Accepts currentLocation
    if not currentLocation then return end              -- Guard clause

    local text = Translations.promptText or "Press [G] to trade"
    local isMarketOpen = true -- New variable to check if market is open

    -- Check if working hours apply and if market is closed
    if currentLocation.StoreHoursAllowed then
        local currentHour = GetClockHours()
        -- DebugPrint(string.format("Checking hours for %s: CurrentHour: %d, StoreOpen: %d, StoreClose: %d",
        --     currentLocation.name, currentHour, currentLocation.StoreOpen, currentLocation.StoreClose))

        -- Fix for working hours check, considering the time of day
        if currentLocation.StoreOpen < currentLocation.StoreClose then -- Working hours within one day (e.g., 9-18)
            isMarketOpen = (currentHour >= currentLocation.StoreOpen and currentHour < currentLocation.StoreClose)
        else                                                           -- Working hours cross midnight (e.g., 18-9)
            isMarketOpen = (currentHour >= currentLocation.StoreOpen or currentHour < currentLocation.StoreClose)
        end

        if not isMarketOpen then
            -- If market is closed, change prompt text to show working hours
            text = Translations.closedMessage ..
                "\n" .. string.format(Translations.workingHours, currentLocation.StoreOpen, currentLocation.StoreClose)
        end
    end
    -- DebugPrint(string.format("Market '%s' is considered: %s", currentLocation.name, isMarketOpen and "OPEN" or "CLOSED"))

    -- Continue with price display logic only if market is open (or if working hours don't apply)
    if isMarketOpen then
        -- Check if currentStockPrices table is empty.
        -- If it is, it means we haven't received price data from the server yet (e.g., after restart).
        if next(currentStockPrices) == nil then
            requestPricesFromServer() -- Request prices if they are missing.
            -- Show "---" instead of general loading message, adding a new line character.
            text = text .. "\n---"
        else
            -- If currentStockPrices is not empty, iterate through stocks in the current location.
            for _, stockId in pairs(currentLocation.stocks) do
                local stock = Config.Stocks[stockId]
                if stock then
                    local serverPriceData = currentStockPrices[stockId]
                    if serverPriceData then
                        -- If server price data for this stock exists, display it, adding a new line character.
                        local sellNet = (serverPriceData.sell or 0) * (1 - (Config.Tax or 0) / 100)
                        text = text ..
                            string.format("\n%s: $%.2f/ $%.2f", stock.label, serverPriceData.buy or 0, sellNet)
                    else
                        -- If the general price data for this stock is loaded (currentStockPrices is not empty),
                        -- but the specific price for this stock is missing, show "---" next to the stock, adding a new line character.
                        text = text .. string.format("\n%s: ---", stock.label)
                    end
                end
            end
        end
    end -- End of isMarketOpen check for prompt text display (text is already prepared)

    -- Move outside the isMarketOpen block to display the text always when near
    DrawText3D(currentLocation.x, currentLocation.y, currentLocation.z + 0.25, text)

    -- Return the isMarketOpen status so the main loop can check it
    return isMarketOpen
end

-- Function to open the menu with a new price request
local function openStockMarketMenu(location)
    requestPricesFromServer() -- Request prices from the server
    Citizen.Wait(100)         -- Small wait

    local elements = {}
    for _, stockId in pairs(location.stocks) do
        local stock = Config.Stocks[stockId]
        if stock then
            local buyPrice = 0
            local sellPrice = 0
            if currentStockPrices[stockId] then
                buyPrice = tonumber(string.format('%.2f', currentStockPrices[stockId].buy or 0))
                sellPrice = tonumber(string.format('%.2f', currentStockPrices[stockId].sell or 0))
            end
            local sellNetDisplay = tonumber(string.format('%.2f', (sellPrice or 0) * (1 - (Config.Tax or 0) / 100)))
            local priceSlash = string.format("%s/%s", buyPrice, sellNetDisplay)
            table.insert(elements, {
                label = stock.label,
                value = stockId,
                desc = "",
                image = stock.item,
                descPrice = {
                    amount = priceSlash, -- Display both prices with slash
                    icon = "money",
                    text = stock.label
                }
            })
        end
    end

    MenuData.Open('default', GetCurrentResourceName(), 'stock_menu', {
        title = location.name, -- Display only location name at the top
        subtext = "",         -- Nothing below the title
        align = 'top-left',
        elements = elements,
        isGrid = true,
        maxVisibleItems = 100,
        enableCursor = false,
        soundOpen = true,
        hideRadar = true
    }, function(data, menu)
        local stockId = data.current.value
        local stock = Config.Stocks[stockId]
        -- Do not calculate price on client side
        local buyPrice = 0
        local sellPrice = 0
        if currentStockPrices[stockId] then
            buyPrice = tonumber(string.format('%.2f', currentStockPrices[stockId].buy or 0))
            sellPrice = tonumber(string.format('%.2f', currentStockPrices[stockId].sell or 0))
        end
        -- Use default format if translation is missing
        local priceFormat = Translations.priceFormat or "$%.2f/$%.2f"
        local priceSlashFormat = Translations.priceSlashFormat or "%s/%s"
        local sellNetDisplay = tonumber(string.format('%.2f', (sellPrice or 0) * (1 - (Config.Tax or 0) / 100)))
        local priceDescription = string.format(priceFormat, buyPrice, sellNetDisplay)
        local amountBuy = 0
        local amountSell = 0
        local priceSlash = string.format(priceSlashFormat, buyPrice, sellNetDisplay)
        local actionElements = {
            {
                label = stock.label,
                value = "info",
                desc = Translations.tradeInfo,
                image = stock.item,
                isNotSelectable = true,
                itemHeight = "6vh",
                descPrice = {
                    amount = priceSlash,
                    icon = "money",
                    text = stock.label
                }
            },
            {
                label = Translations.buyQuantity,
                value = 1,
                desc = buyPrice,
                type = "slider",
                min = 0,
                max = 100,
                hop = 1,
                disabled = false,
                descPrice = {
                    amount = amountBuy,
                    icon = "money",
                    text = Translations.buyText
                }
            },
            {
                label = Translations.sellQuantity,
                value = 0,
                desc = sellPrice,
                type = "slider",
                min = 0,
                max = 100,
                hop = 1,
                disabled = false,
                descPrice = {
                    amount = amountSell,
                    icon = "money",
                    text = Translations.sellText
                }
            },
            {
                label = Translations.confirm,
                value = "confirm",
                desc = "",
                descPrice = {
                    amount = (amountBuy > 0 and amountBuy) or (amountSell > 0 and amountSell) or 0,
                    icon = "money",
                    text = Translations.total
                }
            }
        }

        MenuData.Open('default', GetCurrentResourceName(), 'stock_action_menu', {
            title = stock.label,
            subtext = location.name,
            align = 'top-left',
            elements = actionElements,
            enableCursor = true,
            soundOpen = true,
            hideRadar = true
        }, function(actionData, actionMenu)
            -- submit callback (keep as is)
            local buyQty = actionMenu.data.elements[2].value or 0
            local sellQty = actionMenu.data.elements[3].value or 0
            if actionData.current.value == "confirm" then
                if buyQty > 0 then
                    TriggerServerEvent('stockmarket:buyStock', stockId, buyQty, location.name)
                elseif sellQty > 0 then
                    TriggerServerEvent('stockmarket:sellStock', stockId, sellQty, location.name)
                else
                    VORPcore.NotifyRightTip(Translations.selectQuantity, 4000)
                end
                resetPreviewState()
                actionMenu.close()
                menu.close()
                freezePlayer(false)
                requestPricesFromServer()
            end
        end, function(actionData, actionMenu)
            -- cancel callback: clear global menu variable
            DebugPrint("[MENU_CANCEL] CurrentStockActionMenu set to nil (menu closed)")
            CurrentStockActionMenu = nil
            actionMenu.close()
        end, function(changeData, actionMenu)
            -- change callback: always assign menu object
            CurrentStockActionMenu = actionMenu
            DebugPrint("[MENU_CHANGE] CurrentStockActionMenu set to:", tostring(CurrentStockActionMenu))
            local buyQty = actionMenu.data.elements[2].value or 0
            local sellQty = actionMenu.data.elements[3].value or 0
            local changedIndex = changeData and changeData.current and changeData.current.index or nil
            DebugPrint("[SLIDER_CHANGE] changedIndex:", changedIndex, "buyQty:", buyQty, "sellQty:", sellQty, "CurrentStockActionMenu:", tostring(CurrentStockActionMenu))
            if changedIndex == 2 and buyQty > 0 then
                -- If buy slider is changed, set sell slider to 0
                actionMenu.setElement(3, 'value', 0)
                DebugPrint("[SLIDER_CHANGE] Sending to server: calculateTotal, buy, quantity:", buyQty)
                TriggerServerEvent('stockmarket:calculateTotal', stockId, buyQty, "buy", location.name)
            elseif changedIndex == 3 and sellQty > 0 then
                -- If sell slider is changed, set buy slider to 0
                actionMenu.setElement(2, 'value', 0)
                DebugPrint("[SLIDER_CHANGE] Sending to server: calculateTotal, sell, quantity:", sellQty)
                TriggerServerEvent('stockmarket:calculateTotal', stockId, sellQty, "sell", location.name)
            end
            actionMenu.refresh()
        end)
        -- Immediately after opening the menu, trigger total calculation once the action menu is available
        Citizen.SetTimeout(50, function()
            if MenuData and MenuData.GetOpened then
                local opened = MenuData.GetOpened('stock_action_menu')
                if opened then
                    CurrentStockActionMenu = opened
                    local defaultBuy = (opened.data and opened.data.elements and opened.data.elements[2] and opened.data.elements[2].value) or 0
                    local defaultSell = (opened.data and opened.data.elements and opened.data.elements[3] and opened.data.elements[3].value) or 0
                    if defaultBuy > 0 then
                        TriggerServerEvent('stockmarket:calculateTotal', stockId, defaultBuy, "buy", location.name)
                    elseif defaultSell > 0 then
                        TriggerServerEvent('stockmarket:calculateTotal', stockId, defaultSell, "sell", location.name)
                    end
                end
            end
        end)
    end, function(data, menu)
        resetPreviewState()
        menu.close()
        freezePlayer(false)
        requestPricesFromServer()
    end)
end

-- New function: Checks player proximity and displays 3D text
local function checkProximityAndDisplayInfo()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local currentlyNearLocation = nil
    local isMarketOpenStatus = false -- Will return this status

    for i, locationData in pairs(Config.StockMarketLocations) do
        local distance = Vdist(playerCoords, locationData.x, locationData.y, locationData.z)
        if distance < 2.0 then
            currentlyNearLocation = locationData
            -- displayPromptWithPrices function now not only prepares text but also displays and returns status
            isMarketOpenStatus = displayPromptWithPrices(currentlyNearLocation)
            break -- Exit after finding the closest
        end
    end
    return currentlyNearLocation, isMarketOpenStatus -- Return location and status
end

-- New function: Handles G key press and opens menu or shows closed notification
local function handleMenuInteraction(currentlyNearLocation, isMarketOpenStatus)
    if currentlyNearLocation and IsControlJustReleased(0, Config.keys["G"]) then
        DebugPrint(string.format("G key pressed for %s. Market open status: %s. Attempting to: %s",
            currentlyNearLocation.name, isMarketOpenStatus and "OPEN" or "CLOSED",
            isMarketOpenStatus and "Open Menu" or "Show Closed Notify"))
        if isMarketOpenStatus then
            freezePlayer(true)
            openStockMarketMenu(currentlyNearLocation)
        else
            VORPcore.NotifyRightTip(
                string.format(Translations.marketClosedNotify, currentlyNearLocation.StoreOpen,
                    currentlyNearLocation.StoreClose), 4000)
        end
    end
end

-- Main Client Thread (now just calls functions)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Check every frame if near a market

        local currentlyNearLocation, isMarketOpenStatus = checkProximityAndDisplayInfo()

        handleMenuInteraction(currentlyNearLocation, isMarketOpenStatus)

        -- If player is not near any location, we can wait longer, otherwise check frequently
        if not currentlyNearLocation then
            Citizen.Wait(500) -- Shorter check when far
        end
    end
end)

-- Blip creation and management system (taken from vorp_banking)
local function AddBlip(index)
    local locationData = Config.StockMarketLocations[index]
    if locationData then
        local blip = BlipAddForCoords(1664425300, locationData.x, locationData.y, locationData.z)
        SetBlipSprite(blip, locationData.blipSprite or Config.Blip.sprite, true)
        SetBlipScale(blip, 0.2)
        SetBlipName(blip, locationData.name)
        Config.StockMarketLocations[index].BlipHandle = blip
        DebugPrint(string.format("Created blip for %s", locationData.name))
    end
end

-- Main thread for blip management (fixed version with DoesBlipExist)
CreateThread(function()
    repeat Wait(2000) until LocalPlayer.state.IsInSession

    while true do
        local sleep = 1000
        local player = PlayerPedId()
        local dead = IsEntityDead(player)

        if not dead then
            for index, locationData in pairs(Config.StockMarketLocations) do
                -- First check if BlipHandle exists and is valid
                -- If handle exists, but blip no longer exists, clear the handle so a new blip can be created.
                if Config.StockMarketLocations[index].BlipHandle and not DoesBlipExist(Config.StockMarketLocations[index].BlipHandle) then
                    DebugPrint(string.format(
                        "Blip handle for %s (ID: %s) was invalid or blip no longer exists. Clearing handle to recreate blip.",
                        locationData.name, Config.StockMarketLocations[index].BlipHandle))
                    Config.StockMarketLocations[index].BlipHandle = nil
                end

                -- Create blip if it doesn't exist (or if handle was just cleared, as the old blip no longer existed)
                if not Config.StockMarketLocations[index].BlipHandle then
                    AddBlip(index)
                    DebugPrint(string.format("Blip created or recreated for %s. New handle: %s", locationData.name,
                        Config.StockMarketLocations[index].BlipHandle or "nil"))
                end

                -- Only proceed if BlipHandle exists (i.e., blip exists or was successfully recreated)
                if Config.StockMarketLocations[index].BlipHandle then
                    local currentBlipHandle = Config.StockMarketLocations[index]
                        .BlipHandle -- Use a temporary variable for clarity

                    if locationData.StoreHoursAllowed then
                        local hour = GetClockHours()
                        local isMarketOpen = false

                        if locationData.StoreOpen < locationData.StoreClose then
                            isMarketOpen = (hour >= locationData.StoreOpen and hour < locationData.StoreClose)
                        else
                            isMarketOpen = (hour >= locationData.StoreOpen or hour < locationData.StoreClose)
                        end

                        -- Remove old color modifiers before adding new ones
                        BlipRemoveModifier(currentBlipHandle, joaat('BLIP_MODIFIER_MP_COLOR_10')) -- Red
                        BlipRemoveModifier(currentBlipHandle, joaat('BLIP_MODIFIER_MP_COLOR_32')) -- Green

                        if isMarketOpen then
                            BlipAddModifier(currentBlipHandle, joaat('BLIP_MODIFIER_MP_COLOR_32')) -- Set green
                            -- DebugPrint(string.format("Blip for %s (handle: %s) set to GREEN (Open). Current hour: %s", locationData.name, currentBlipHandle, hour))
                        else
                            BlipAddModifier(currentBlipHandle, joaat('BLIP_MODIFIER_MP_COLOR_10')) -- Set red
                            -- DebugPrint(string.format("Blip for %s (handle: %s) set to RED (Closed). Current hour: %s", locationData.name, currentBlipHandle, hour))
                        end
                    else -- Working hours do not apply, always open (green color)
                        BlipRemoveModifier(currentBlipHandle, joaat('BLIP_MODIFIER_MP_COLOR_10'))
                        BlipAddModifier(currentBlipHandle, joaat('BLIP_MODIFIER_MP_COLOR_32'))
                        -- DebugPrint(string.format("Blip for %s (handle: %s) set to GREEN (Always Open).", locationData.name, currentBlipHandle))
                    end

                    local distance = getDistance(locationData)
                    if distance <= 2.0 then
                        sleep = 0 -- If close to any blip, check frequently
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

-- Removing blips when the resource stops
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        DebugPrint("Removing all blips...")
        for index, locationData in pairs(Config.StockMarketLocations) do
            if locationData.BlipHandle then
                RemoveBlip(locationData.BlipHandle)
            end
        end
        -- Close any open menus on restart/stop
        if MenuData and MenuData.GetOpened then
            local actionMenu = MenuData.GetOpened('stock_action_menu')
            if actionMenu and actionMenu.close then actionMenu.close() end
            local rootMenu = MenuData.GetOpened('stock_menu')
            if rootMenu and rootMenu.close then rootMenu.close() end
        end
        CurrentStockActionMenu = nil
        resetPreviewState()
        freezePlayer(false)
        DebugPrint("All blips removed.")
    end
end)
