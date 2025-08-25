-----------------------
--- Dead-ServerList ---
-----------------------



--- CODE ---
avatars = {}
discordNames = {}
RegisterNetEvent('Dead-ServerList:SetupImg')
AddEventHandler('Dead-ServerList:SetupImg', function()
    -- Add their avatar 
    local src = source;
    local license = ExtractIdentifiers(src).license;
    -- Only run this code if they have not been set up already 
    if avatars[license] == nil then 
        local ava = GetAvatar(src);
        local discordName = GetDiscordName(src);
        if (ava ~= nil) then 
            avatars[license] = ava;
        else 
            avatars[license] = Config.Default_Profile;
        end
        if (discordName ~= nil) then 
            discordNames[license] = discordName;
        else 
            discordNames[license] = Config.Discord_Not_Found;
        end
    end
end)
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        -- It's this resource 
        for _, id in pairs(GetPlayers()) do 
            TriggerEvent('Dead-ServerList:SetupRestart', id);
        end
    end
end)
RegisterNetEvent('Dead-ServerList:SetupRestart')
AddEventHandler('Dead-ServerList:SetupRestart', function(src)
    -- Add their avatar 
    local ava = GetAvatar(src);
    local discordName = GetDiscordName(src);
    local license = ExtractIdentifiers(src).license;
    if (ava ~= nil) then 
        avatars[license] = ava;
    else 
        avatars[license] = Config.Default_Profile;;
    end
    if (discordName ~= nil) then 
        discordNames[license] = discordName;
    else 
        discordNames[license] = Config.Discord_Not_Found;
    end
end)
Citizen.CreateThread(function()
    while true do 
        Wait((1000 * 5)); -- Every 5 seconds, update 
        local avatarIDs = {};
        local pings = {};
        local players = {};
        local discords = {};
        for _, id in ipairs(GetPlayers()) do 
            local license = ExtractIdentifiers(id).license;
            local ping = GetPlayerPing(id); 
            players[id] = GetPlayerName(id);
            pings[id] = ping;
            if (avatars[license] ~= nil) then 
                avatarIDs[id] = avatars[license];
            else 
                avatarIDs[id] = Config.Default_Profile;
            end
            if (discordNames[license] ~= nil) then 
                discords[id] = discordNames[license]
            else 
                discords[id] = Config.Discord_Not_Found;
            end
        end
        TriggerClientEvent('Dead-ServerList:PlayerUpdate', -1, players)
        TriggerClientEvent('Dead-ServerList:PingUpdate', -1, pings)
        TriggerClientEvent('Dead-ServerList:ClientUpdate', -1, avatarIDs)
        TriggerClientEvent('Dead-ServerList:DiscordUpdate', -1, discords)
    end
end)


function GetAvatar(user) 
    return exports.Dead_Discord_API:GetDiscordAvatar(user);
end
function GetDiscordName(user) 
    return exports.Dead_Discord_API:GetDiscordName(user);
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end