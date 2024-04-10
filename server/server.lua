local RSGCore = exports['rsg-core']:GetCoreObject()
local ResetStress = false



-------- commands
lib.addCommand('cash', {
    help = locale("cash"),
}, function(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    local cashamount = Player.PlayerData.money.cash
    if cashamount ~= nil then
        TriggerClientEvent('hud:client:ShowAccounts', source, 'cash', cashamount)
    else
        return
    end
end)



lib.addCommand('bank', {
    help = locale("bank"),
}, function(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    local bankamount = Player.PlayerData.money.bank
    if bankamount ~= nil then
        TriggerClientEvent('hud:client:ShowAccounts', source, 'bank', bankamount)
    else
        return
    end
end)
lib.addCommand('bloodmoney', {
    help = locale("blood"),
}, function(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    local bloodmoneyamount = Player.PlayerData.money.bloodmoney
    if bloodmoneyamount ~= nil then
        TriggerClientEvent('hud:client:ShowAccounts', source, 'bloodmoney', bloodmoneyamount)
    else
        return
    end
end)


RegisterNetEvent('hud:server:GainStress', function(amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local newStress
    if Player ~= nil and Player.PlayerData.job.name ~= 'police' then
        if not ResetStress then
            if Player.PlayerData.metadata['stress'] == nil then
                Player.PlayerData.metadata['stress'] = 0
            end
            newStress = Player.PlayerData.metadata['stress'] + amount
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.Functions.SetMetaData('stress', newStress)
        TriggerClientEvent('hud:client:UpdateStress', src, newStress)
        TriggerClientEvent('ox_lib:notify', src, {title = locale("info.getstress"), type = 'inform', duration = 5000 })
    end
end)

RegisterNetEvent('hud:server:GainThirst', function(amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local newThirst
    if Player ~= nil then
            if Player.PlayerData.metadata['thirst'] == nil then
                Player.PlayerData.metadata['thirst'] = 0
            end
            local thirst = Player.PlayerData.metadata['thirst']
            if newThirst <= 0 then
                newThirst = 0
            end
            if newThirst > 100 then
                newThirst = 100
            end
        Player.Functions.SetMetaData('thirst', newThirst)
        TriggerClientEvent('hud:client:UpdateThirst', src, newThirst)
        TriggerClientEvent('ox_lib:notify', src, {title = locale("info.thirsty"), type = 'inform', duration = 5000 })
    end
end)

RegisterNetEvent('hud:server:RelieveStress', function(amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local newStress
    if Player ~= nil then
        if not ResetStress then
            if Player.PlayerData.metadata['stress'] == nil then
                Player.PlayerData.metadata['stress'] = 0
            end
            newStress = Player.PlayerData.metadata['stress'] - amount
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.Functions.SetMetaData('stress', newStress)
        TriggerClientEvent('hud:client:UpdateStress', src, newStress)
        TriggerClientEvent('ox_lib:notify', src, {title = locale("info.relaxing"), type = 'inform', duration = 5000 })
    end
end)

-- count telegrams for player
if Config.telegram then
RSGCore.Functions.CreateCallback('hud:server:getTelegramsAmount', function(source, cb)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local result = MySQL.prepare.await('SELECT COUNT(*) FROM telegrams WHERE citizenid = ? AND (status = ? OR birdstatus = ?)', {Player.PlayerData.citizenid, 0, 0})
    if result > 0 then
        cb(result)
    else
        cb(0)
    end
end)
end
lib.versionCheck('StrixLuca/strix_hud-edit')