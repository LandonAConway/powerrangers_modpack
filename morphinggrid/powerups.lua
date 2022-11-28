morphinggrid.registered_powerups = {}

function morphinggrid.get_powerup_status(player)
    if type(player) == "string" then player = minetest.get_player_by_name(player) end
    local mstatus = morphinggrid.get_morph_status(player)
    local pustatus = player:get_meta():get_string("morphinggrid_powerup_status")
    if morphinggrid.registered_rangers[mstatus] and morphinggrid.registered_powerups[pustatus] then
        return pustatus
    end
end

local function default_max_enegry(player, ranger, powerup)
    local def = morphinggrid.registered_rangers[ranger]
    local value = def.max_energy
    if type(value) == "function" then value = value(player, ranger) end
    return value * 1.75
end

local function default_energy_on_powerup(player, ranger, powerup)
    local def = morphinggrid.registered_powerups[powerup]
    return def.max_energy(player, ranger, powerup)
end

local function default_energy_on_powerdown(player, ranger, powerup)
    local def = morphinggrid.registered_rangers[ranger]
    local value = def.max_energy
    if type(value) == "function" then value = value(player, ranger) end
    return value
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
        if type(def.get_rtextures) == "function" then
            local override = def.get_rtextures(player, ranger, powerup)
            rtextures.boots.armor = override.boots.armor or rtextures.boots.armor
            rtextures.leggings.armor = override.leggings.armor or rtextures.leggings.armor
            rtextures.chestplate.armor = override.chestplate.armor or rtextures.chestplate.armor
            rtextures.helmet.armor = override.helmet.armor or rtextures.helmet.armor
        end
        return rtextures
    end
end

function morphinggrid.powerup(player, powerup, powerupargs)
    powerupargs = powerupargs or {}
    if powerupargs.chat_messages == nil then powerupargs.chat_messages = true end

    local meta = player:get_meta()
    local ranger = morphinggrid.get_morph_status(player)
    if not morphinggrid.registered_rangers[ranger] then return false end
    
    local def = morphinggrid.registered_powerups[powerup]
    if def then
        morphinggrid.powerdown(player, {chat_messages=false})

        --set the powerup. This must be done first so all of the other functions will react to the powerup
        meta:set_string("morphinggrid_powerup_status", powerup)

        --change the player's energy levels etc...
        local rdata = morphinggrid.get_rangerdata(player, ranger)
        rdata:set_energy_level(def.energy_on_powerup(player, ranger, powerup))

        --update the visuals of the player and the hud
        morphinggrid.update_player_visuals(player)
        morphinggrid.hud_update_power_usage(player)

        --callbacks
        if type(def.on_powerup) == "function" then
            def.on_powerup(player, ranger)
        end
        
        if powerupargs.chat_messages == true then
            minetest.chat_send_player(player:get_player_name(), "Power Up Successful (Powerup: " .. (def.description or def.name) .. ")")
        end
        minetest.log("action", "Player (" .. player:get_player_name() .. ") Powered Up: " .. def.name)

        return true
    end
    return false
end

function morphinggrid.powerdown(player, powerdownargs)
    powerdownargs = powerdownargs or {}
    if powerdownargs.chat_messages == nil then powerdownargs.chat_messages = true end

    local meta = player:get_meta()
    local ranger = morphinggrid.get_morph_status(player)
    local powerup = morphinggrid.get_powerup_status(player)
    if not morphinggrid.registered_rangers[ranger] then return false end

    local def = morphinggrid.registered_powerups[powerup]
    if def then
        --set the powerup. This must be done first so all of the other functions will react to the powerup
        meta:set_string("morphinggrid_powerup_status", "")

        --change the player's energy levels etc...
        local rdata = morphinggrid.get_rangerdata(player, ranger)
        rdata:set_energy_level(def.energy_on_powerdown(player, ranger, powerup))

        --update the visuals of the player and the hud
        morphinggrid.update_player_visuals(player)
        morphinggrid.hud_update_power_usage(player)

        --callbacks
        if type(def.on_powerdown) == "function" then
            def.on_powerdown(player, ranger)
        end

        if powerdownargs.chat_messages == true then
            minetest.chat_send_player(player:get_player_name(), "Power Down Successful (Powerup: " .. (def.description or def.name) .. ")")
        end
        minetest.log("action", "Player (" .. player:get_player_name() .. ") Powered Down: " .. def.name)

        return true
    end
    return false
end