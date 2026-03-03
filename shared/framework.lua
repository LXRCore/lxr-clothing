--[[
    ██╗     ██╗  ██╗██████╗        ██████╗██╗      ██████╗ ████████╗██╗  ██╗██╗███╗   ██╗ ██████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██║     ██╔═══██╗╚══██╔══╝██║  ██║██║████╗  ██║██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║     ██║   ██║   ██║   ███████║██║██╔██╗ ██║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║     ██║   ██║   ██║   ██╔══██║██║██║╚██╗██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗███████╗╚██████╔╝   ██║   ██║  ██║██║██║ ╚████║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝

    🐺 LXR Clothing System — Framework Bridge
    Unified multi-framework API for lxr-clothing

    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════

    Server:    The Land of Wolves 🐺
    Developer: iBoss21 / The Lux Empire
    Website:   https://www.wolves.land
    Discord:   https://discord.gg/CrKcWdfd3A
    Store:     https://theluxempire.tebex.io

    ═══════════════════════════════════════════════════════════════════════════════

    Supported Frameworks:
    - LXR-Core  (Primary)
    - RSG-Core  (Primary)
    - VORP Core (Supported)
    - Standalone (Fallback)

    ═══════════════════════════════════════════════════════════════════════════════
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK BRIDGE ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Framework = {}
Framework.Name = 'lxr-core' -- default, overridden at runtime

-- ═══════════════════════════════════════════════════════════════════════════════
-- Framework detection — runs at resource start
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    if Config.Framework ~= 'auto' then
        Framework.Name = Config.Framework
    elseif GetResourceState('lxr-core') == 'started' then
        Framework.Name = 'lxr-core'
    elseif GetResourceState('rsg-core') == 'started' then
        Framework.Name = 'rsg-core'
    elseif GetResourceState('vorp_core') == 'started' then
        Framework.Name = 'vorp_core'
    else
        Framework.Name = 'standalone'
    end

    print(string.format('[lxr-clothing] 🐺 Framework detected: %s', Framework.Name))
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ CLIENT-SIDE BRIDGE ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

if not IsDuplicityVersion() then

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Framework.TriggerCallback — trigger a server-side callback from the client
    -- ─────────────────────────────────────────────────────────────────────────────
    Framework.TriggerCallback = function(name, cb, ...)
        if Framework.Name == 'lxr-core' then
            exports['lxr-core']:TriggerCallback(name, cb, ...)
        elseif Framework.Name == 'rsg-core' then
            exports['rsg-core']:TriggerCallback(name, cb, ...)
        elseif Framework.Name == 'vorp_core' then
            exports['vorp_core']:executeCallback(name, cb, ...)
        else
            -- Standalone: fire-and-forget, cb receives nothing
            cb(nil)
        end
    end

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Framework.GetPlayerData — return the local player's data table
    -- ─────────────────────────────────────────────────────────────────────────────
    Framework.GetPlayerData = function()
        if Framework.Name == 'lxr-core' then
            return exports['lxr-core']:GetPlayerData()
        elseif Framework.Name == 'rsg-core' then
            return exports['rsg-core']:GetPlayerData()
        else
            return {}
        end
    end

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Framework.CreatePrompt — create a world-space interaction prompt
    -- ─────────────────────────────────────────────────────────────────────────────
    Framework.CreatePrompt = function(id, coords, key, label, options)
        if Framework.Name == 'lxr-core' then
            exports['lxr-core']:createPrompt(id, coords, key, label, options)
        elseif Framework.Name == 'rsg-core' then
            exports['rsg-core']:createPrompt(id, coords, key, label, options)
        end
        -- VORP / standalone: no unified prompt export; handled via native markers
    end

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Framework.PlayerLoadedEvent — the client event fired when a player is loaded
    -- ─────────────────────────────────────────────────────────────────────────────
    Framework.PlayerLoadedEvent = function()
        if Framework.Name == 'lxr-core' then
            return 'LXRCore:Client:OnPlayerLoaded'
        elseif Framework.Name == 'rsg-core' then
            return 'RSGCore:Client:OnPlayerLoaded'
        elseif Framework.Name == 'vorp_core' then
            return 'VORP:SelectedCharacter'
        else
            return 'playerLoaded'
        end
    end

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Framework.TriggerPlayerLoaded — fire the server-side player-loaded event
    -- ─────────────────────────────────────────────────────────────────────────────
    Framework.TriggerPlayerLoaded = function()
        if Framework.Name == 'lxr-core' then
            TriggerServerEvent('LXRCore:Server:OnPlayerLoaded')
            TriggerEvent('LXRCore:Client:OnPlayerLoaded')
        elseif Framework.Name == 'rsg-core' then
            TriggerServerEvent('RSGCore:Server:OnPlayerLoaded')
            TriggerEvent('RSGCore:Client:OnPlayerLoaded')
        elseif Framework.Name == 'vorp_core' then
            TriggerEvent('VORP:SelectedCharacter')
        end
    end

end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER-SIDE BRIDGE ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

if IsDuplicityVersion() then

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Framework.GetPlayer — return a normalised player object from any framework
    -- Returns a table with at minimum: { PlayerData = { citizenid = '...' } }
    -- ─────────────────────────────────────────────────────────────────────────────
    Framework.GetPlayer = function(src)
        if Framework.Name == 'lxr-core' then
            return exports['lxr-core']:GetPlayer(src)
        elseif Framework.Name == 'rsg-core' then
            return exports['rsg-core']:GetPlayer(src)
        elseif Framework.Name == 'vorp_core' then
            local user      = exports['vorp_core']:getUser(src)
            local character = user and user:getUsedCharacter()
            if character then
                return { PlayerData = { citizenid = tostring(character:getIdentifier()) } }
            end
            return nil
        else
            return nil
        end
    end

    -- ─────────────────────────────────────────────────────────────────────────────
    -- Framework.CreateCallback — register a server-side callback
    -- ─────────────────────────────────────────────────────────────────────────────
    Framework.CreateCallback = function(name, cb)
        if Framework.Name == 'lxr-core' then
            exports['lxr-core']:CreateCallback(name, cb)
        elseif Framework.Name == 'rsg-core' then
            exports['rsg-core']:CreateCallback(name, cb)
        elseif Framework.Name == 'vorp_core' then
            exports['vorp_core']:addCallback(name, cb)
        end
    end

end
