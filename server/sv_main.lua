exports['lxr-core']:CreateCallback('lxr-clothing:server:isPlayerNew', function(source, cb)
    local src = source
    local Player = exports['lxr-core']:GetPlayer(src)
    local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid=@citizenid AND active=@active', {['@citizenid'] = Player.PlayerData.citizenid, ['@active'] = 1})
    if (result[1] == nil) then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("lxr-clothing:server:saveSkin")
AddEventHandler('lxr-clothing:server:saveSkin', function(model, skin, clothes)
    local src = source
    local Player = exports['lxr-core']:GetPlayer(src)
    if model ~= nil and skin ~= nil then
        MySQL.query('DELETE FROM playerskins WHERE citizenid=@citizenid', {['@citizenid'] = Player.PlayerData.citizenid}, function()
            MySQL.insert.await('INSERT INTO playerskins (citizenid, model, skin, clothes, active) VALUES (@citizenid, @model, @skin, @clothes, @active)', {
                ['@citizenid'] = Player.PlayerData.citizenid,
                ['@model'] = model,
                ['@clothes'] = clothes,
                ['@skin'] = skin,
                ['@active'] = 1
            })
        end)
    end
end)

RegisterServerEvent("lxr-clothing:server:saveOutfit")
AddEventHandler("lxr-clothing:server:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = exports['lxr-core']:GetPlayer(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        MySQL.query.await('INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (@citizenid, @outfitname, @model, @skin, @outfitId)', {
            ['@citizenid'] = Player.PlayerData.citizenid,
            ['@outfitname'] = outfitName,
            ['@model'] = model,
            ['@skin'] = skinData,
            ['@outfitId'] = outfitId
        })
        local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = @citizenid', { ['@citizenid'] = Player.PlayerData.citizenid })
        if result[1] ~= nil then
            TriggerClientEvent('lxr-clothing:client:reloadOutfits', src, result)
        else
            TriggerClientEvent('lxr-clothing:client:reloadOutfits', src, nil)
        end
    end
end)

RegisterServerEvent("lxr-clothing:server:removeOutfit")
AddEventHandler("lxr-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = exports['lxr-core']:GetPlayer(src)
    MySQL.query.await('DELETE player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (@citizenid, @outfitname, @model, @skin, @outfitId)', {
        ['@citizenid'] = Player.PlayerData.citizenid,
        ['@outfitname'] = outfitName,
        ['@model'] = model,
        ['@skin'] = skinData,
        ['@outfitId'] = outfitId
    })
    local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = @citizenid', { ['@citizenid'] = Player.PlayerData.citizenid })
    if result[1] ~= nil then
        TriggerClientEvent('lxr-clothing:client:reloadOutfits', src, result)
    else
        TriggerClientEvent('lxr-clothing:client:reloadOutfits', src, nil)
    end
end)

exports['lxr-core']:CreateCallback('lxr-clothing:server:getOutfits', function(source, cb)
    local Player = exports['lxr-core']:GetPlayer(source)
    local retVal = {}

    local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid=@citizenid', {['@citizenid'] = Player.PlayerData.citizenid})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            result[k].skin = json.decode(result[k].skin)
            retVal[k] = v
        end
        cb(retVal)
    end
    cb(retVal)
end)
