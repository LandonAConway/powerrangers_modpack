morphinggrid.registered_powerups = {}

function morphinggrid.get_powerup_status(player)
    if type(player) == "string" then player = minetest.get_player_by_name(player) end
    local mstatus = morphinggrid.get_morph_status(player)
    local pustatus = player:get_meta():get_string("morphinggrid_powerup_status")
    if morphinggrid.registered_rangers[mstatus] and morphinggrid.registered_powerups[pustatus] then
        return pustatus
    end
end

local function default_max_enegry(player, ranger, powerup, last_max_energy, last_energy_level)
    local def = morphinggrid.registered_powerups[powerup]
    return last_max_energy + (def.add_energy or (last_max_energy*(def.mult_energy or 0.5)))
end

local function default_energy_on_powerup(player, ranger, powerup, last_max_energy, last_energy_level)
    local rdata = morphinggrid.get_rangerdata(player, ranger)
    local def = morphinggrid.registered_powerups[powerup]
    local cenergy = rdata:get_energy_level()
    return cenergy + (def.add_energy or (cenergy*(def.mult_energy or 0.5)))
end

local function default_energy_on_powerdown(player, ranger, powerup, last_max_energy, last_energy_level)
    local rdata = morphinggrid.get_rangerdata(player, ranger)
    local def = morphinggrid.registered_powerups[powerup]
    local percent = last_energy_level / last_max_energy
    return rdata:get_max_energy() * percent
end

function morphinggrid.register_powerup(name, def)
    def.name = name
    def.max_energy = def.max_energy or default_max_enegry
    def.energy_on_powerup = def.energy_on_powerup or default_energy_on_powerup
    def.energy_on_powerdown = def.energy_on_powerdown or default_energy_on_powerdown
    def.rtextures = def.rtextures or {}
    def.rtextures.boots = def.rtextures.boots or {}
    def.rtextures.leggings = def.rtextures.leggings or {}
    def.rtextures.chestplate = def.rtextures.chestplate or {}
    def.rtextures.helmet = def.rtextures.helmet or {}
    morphinggrid.registered_powerups[name] = def
end


function morphinggrid.get_powerup_textures(player, ranger, powerup)
    if type(player) == "string" then player = minetest.get_player_by_name(player) end
    local def = morphinggrid.registered_powerups[powerup]
    if def then
        local rtextures = def.rtextures
        if type(rtextures) == "function" then
            rtextures = def.rtextures(player, ranger, powerup)
        end
        return rtextures
    end
end

function morphinggrid.player_get_powerups_list(player)
    if type(player) == "string" then player = minetest.get_player_by_name(player) end
    local meta = player:get_meta()
    return minetest.deserialize(meta:get_string("morphinggrid_powerups")) or {}
end

function morphinggrid.player_get_powerups(player)
    local meta = player:get_meta()
    local list = morphinggrid.player_get_powerups_list(player)
    local powerups = {}
    for _, p in pairs(list) do
        powerups[p] = true
    end
    return powerups
end

function morphinggrid.player_check_powerups(player, powerups)
    local current = morphinggrid.player_get_powerups(player)
    for k, v in pairs(powerups) do
        if current[k] ~= true then
            return false
        end
    end
    return true
end

local function has_value(t, value)
    for k, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

local function player_set_powerups_list(player, powerups)
    if type(player) == "string" then player = minetest.get_player_by_name(player) end
    local meta = player:get_meta()
    meta:set_string("morphinggrid_powerups", minetest.serialize(powerups))
end

local function player_add_powerup(player, powerup)
    local list = morphinggrid.player_get_powerups(player)
    if not has_value(list, powerup) then
        table.insert(list, powerup)
    end
    player_set_powerups_list(player, list)
end

local function player_remove_powerup(player, powerup)
    local list = morphinggrid.player_get_powerups_list(player)
    local newList = {}
    for _, p in pairs(list) do
        if p ~= powerup then
            table.insert(newList, p)
        end
    end
    player_set_powerups_list(player, newList)
end

local check_privs = function(player, powerup)
    if type(powerup) == "string" then
        powerup = morphinggrid.registered_powerups[powerup]
    end

    local privs_to_check = {
        power_rangers = true
    }
    for _, p in pairs(powerup.privs or {}) do
        privs_to_check[p] = true
    end

    local missing_privs = {}
    for p, v in pairs(privs_to_check) do
        if not minetest.check_player_privs(player:get_player_name(), {
            p = v
        }) then
            table.insert(missing_privs, p)
        end
    end

    return minetest.check_player_privs(player:get_player_name(), privs_to_check), missing_privs
end

function morphinggrid.powerup(player, powerup, powerupsettings)
    if type(player) == "string" then player = minetest.get_player_by_name(player) end
    powerupsettings = powerupsettings or {}
    if powerupsettings.chat_messages == nil then powerupsettings.chat_messages = true end

    local ranger = morphinggrid.get_morph_status(player)
    if not morphinggrid.registered_rangers[ranger] then return false end
    
    local def = morphinggrid.registered_powerups[powerup]
    if def then
        --check privs
        if def.privs and not powerupsettings.bypass_privs then
            if not minetest.player_check_privs(player, def.privs) then
                local _, missing_privs = check_privs(player, powerup)
                if powerupsettings.chat_messages then
                    minetest.chat_send_player(player:get_player_name(),
                        "You don't have permisson to use this powerup (Missing Privileges: " .. table.concat(missing_privs, ", ") .. " )")
                end
                return false
            end
        end

        morphinggrid.powerdown(player, {chat_messages=false})

        --set the powerup. This must be done first so all of the other functions will react to the powerup
        --before setting it, we need to get some data because it will change afterwards
        local rdata = morphinggrid.get_rangerdata(player, ranger)
        local last_max_energy = rdata:get_max_energy()
        local last_energy_level = rdata:get_energy_level()
        player_add_powerup(player, powerup)

        --change the player's energy levels etc...
        local rdata = morphinggrid.get_rangerdata(player, ranger)
        rdata:set_energy_level(def.energy_on_powerup(player, ranger, powerup, last_max_energy, last_energy_level))

        --update the visuals of the player and the hud
        morphinggrid.update_player_visuals(player)
        morphinggrid.hud_update_power_usage(player)

        --callbacks
        if type(def.on_powerup) == "function" then
            def.on_powerup(player, ranger)
        end
        
        if powerupsettings.chat_messages == true then
            minetest.chat_send_player(player:get_player_name(), "Power up successful (Powerup: " .. (def.description or def.name) .. ")")
        end
        minetest.log("action", "Player (" .. player:get_player_name() .. ") Powered up: " .. def.name)

        return true
    end
    return false
end

local function reverse_table(t)
    local result = {}
    for k, v in pairs(t) do
        table.insert(result, 1, v)
    end
    return result
end

function morphinggrid.powerdown(player, powerup, powerdownsettings)
    if type(player) == "string" then player = minetest.get_player_by_name(player) end
    powerdownsettings = powerdownsettings or {}
    if powerdownsettings.chat_messages == nil then powerdownsettings.chat_messages = true end

    local ranger = morphinggrid.get_morph_status(player)
    if not morphinggrid.registered_rangers[ranger] then return false end

    local def = morphinggrid.registered_powerups[powerup]
    if def then
        --check privs
        if def.privs and not powerdownsettings.bypass_privs then
            if not minetest.player_check_privs(player, def.privs) then
                local _, missing_privs = check_privs(player, powerup)
                if powerdownsettings.chat_messages then
                    minetest.chat_send_player(player:get_player_name(),
                        "You don't have permisson to use this powerup (Missing Privileges: " .. table.concat(missing_privs, ", ") .. " )")
                end
                return false
            end
        end

        --set the powerup. This must be done first so all of the other functions will react to the powerup
        --before setting it, we need to get some data because it will change afterwards
        local rdata = morphinggrid.get_rangerdata(player, ranger)
        local last_max_energy = rdata:get_max_energy()
        local last_energy_level = rdata:get_energy_level()
        player_remove_powerup(player, powerup)

        --change the player's energy levels etc...
        local rdata = morphinggrid.get_rangerdata(player, ranger)
        rdata:set_energy_level(def.energy_on_powerdown(player, ranger, powerup, last_max_energy, last_energy_level))

        --update the visuals of the player and the hud
        morphinggrid.update_player_visuals(player)
        morphinggrid.hud_update_power_usage(player)

        --callbacks
        if type(def.on_powerdown) == "function" then
            def.on_powerdown(player, ranger)
        end

        if powerdownsettings.chat_messages == true then
            minetest.chat_send_player(player:get_player_name(), "Power down successful (Powerup: " .. (def.description or def.name) .. ")")
        end
        minetest.log("action", "Player (" .. player:get_player_name() .. ") Powered down: " .. def.name)

        return true
    elseif def == nil then
        for _, _powerup in pairs(reverse_table(morphinggrid.player_get_powerups_list(player))) do
            morphinggrid.powerdown(player, _powerup, powerdownsettings)
            return true
        end
    end
    return false
end