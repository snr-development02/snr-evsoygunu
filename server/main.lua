local QBCore = exports['qb-core']:GetCoreObject()

-- Functions

local function ResetHouseStateTimer(house)
    local num = math.random(3333333, 11111111)
    local time = tonumber(num)
    SetTimeout(time, function()
        Config.Houses[house]["opened"] = false
        for k, v in pairs(Config.Houses[house]["furniture"]) do
            v["searched"] = false
        end
        TriggerClientEvent('snr:client:ResetHouseState', -1, house)
    end)
end

-- Callbacks

QBCore.Functions.CreateUseableItem("lockpick2", function(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)

    if xPlayer.Functions.GetItemByName("lockpick2").amount >= 1 then
        TriggerClientEvent("lockpicks:UseLockpick", source)
    else
        TriggerClientEvent("QBCore:Notify", source, 'Üzerinde maymuncuk yok!', "error")
    end
end)

QBCore.Functions.CreateCallback('snr:server:GetHouseConfig', function(source, cb)
    cb(Config.Houses)
end)

-- Events

RegisterNetEvent('snr:server:SetBusyState', function(cabin, house, bool)
    Config.Houses[house]["furniture"][cabin]["isBusy"] = bool
    TriggerEvent('snr:client:SetBusyState', -1, cabin, house, bool)
end)

RegisterNetEvent('snr:server:enterHouse', function(house)
    local src = source
    if not Config.Houses[house]["opened"] then
        ResetHouseStateTimer(house)
        TriggerClientEvent('snr:client:setHouseState', -1, house, true)
    end
    TriggerClientEvent('snr:client:enterHouse', src, house)
    Config.Houses[house]["opened"] = true
end)

RegisterNetEvent('snr:server:searchCabin', function(cabin, house)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local luck = math.random(1, 10)
    local itemFound = math.random(1, 4)
    local itemCount = 1

    local Tier = 1
    if Config.Houses[house]["tier"] == 1 then
        Tier = 1
    elseif Config.Houses[house]["tier"] == 2 then
        Tier = 2
    elseif Config.Houses[house]["tier"] == 3 then
        Tier = 3
    end

    if itemFound < 4 then
        if luck == 10 then
            itemCount = 3
        elseif luck >= 6 and luck <= 8 then
            itemCount = 2
        end

        for i = 1, itemCount, 1 do
            local randomItem = Config.Rewards[Tier][Config.Houses[house]["furniture"][cabin]["type"]][math.random(1, #Config.Rewards[Tier][Config.Houses[house]["furniture"][cabin]["type"]])]
            local itemInfo = QBCore.Shared.Items[randomItem]
            if math.random(1, 100) == 69 then
                randomItem = "water"
                itemInfo = QBCore.Shared.Items[randomItem]
                Player.Functions.AddItem(randomItem, 2)
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            elseif math.random(1, 100) == 35 then
                    randomItem = "jewels"
                    itemInfo = QBCore.Shared.Items[randomItem]
                    Player.Functions.AddItem(randomItem, 1)
                    TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            else
                if not itemInfo["unique"] then
                    local itemAmount = 1
                    if randomItem == "walkie_lspd" then
                        itemAmount = 1
                    elseif randomItem == "altinyuzuk" then
                        itemAmount = 1
                    elseif randomItem == "water" then
                        itemAmount = 1
                    elseif randomItem == "methlab" then
                        itemAmount = 1
                    elseif randomItem == "kraker" then
                        itemAmount = 1
                    end

                    Player.Functions.AddItem(randomItem, itemAmount)
                else
                    Player.Functions.AddItem(randomItem, 1)
                end
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            end
            Wait(500)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Boş!", 'error')
    end

    Config.Houses[house]["furniture"][cabin]["searched"] = true
    TriggerClientEvent('snr:client:setCabinState', -1, house, cabin, true)
end)
