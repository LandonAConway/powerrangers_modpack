local combine_tables = function(...)
    local result = {}
    for _, t in pairs({...}) do
        for _, stack in pairs(t) do
            table.insert(result, stack)
        end
    end
    return result
end

--The purpose of this function is not directly related to the ranger's armor, however it is used by register_on_player_hpchange.
--This function calculates the hp that will be returned from the grid item's or morphers that are in a player's inventory which
--modify the hp of a player.
local get_multiplied_hp = function(player, hp_change)
    local player_main = player:get_inventory():get_list("main")
    local morphers_main = morphinggrid.morphers.get_inventory(player):get_list("main")
    local morphers_single = morphinggrid.morphers.get_inventory(player):get_list("single")

    local product = hp_change
    for _, stack in pairs(combine_tables(player_main, morphers_main, morphers_single)) do
        local griditemdef = morphinggrid.registered_griditems[stack:get_name()]
        local morpherdef = morphinggrid.registered_morphers[stack:get_name()]
        local hp_multiplier = 1
        if griditemdef then
            if type(griditemdef.hp_multiplier) == "number" then
                hp_multiplier = griditemdef.hp_multiplier
            elseif type(griditemdef.hp_multiplier) == "function" then
                hp_multiplier = griditemdef.hp_multiplier(player, hp_change, product, stack) or 1
            end
        elseif morpherdef then
            if type(morpherdef.hp_multiplier) == "number" then
                hp_multiplier = morpherdef.hp_multiplier
            elseif type(morpherdef.hp_multiplier) == "function" then
                hp_multiplier = morpherdef.hp_multiplier(player, hp_change, product, stack) or 1
            end
        end
        product = product * hp_multiplier
    end

    return product
end

--prevents the player from having their hp change when morphed, instead affects the ranger armor
local handle_3d_armor = function(player, hp_change, reason)
    if player and reason.type ~= "drown" and reason.hunger == nil then
        local name = player:get_player_name()
        if name then
            local heal = armor.def[name].heal
            math.randomseed(os.time())
            if heal >= math.random(100) then
                hp_change = 0
            end
        end
    end
    return hp_change
end

if morphinggrid.chat_send_admins == nil then error("chat_send_admins is still nil!") end

minetest.register_on_player_hpchange(function(player, hp_change, reason)
    if morphinggrid.debug then morphinggrid.chat_send_admins("hpchange: "..hp_change) end
    if hp_change < 0 then
        if morphinggrid.get_morph_status(player) then
            morphinggrid.get_current_rangerdata(player):damage_energy_hp(hp_change*-1)
            morphinggrid.hud_update_power_usage(player)
            if morphinggrid.debug then morphinggrid.chat_send_admins("hpchange_morphed: "..(hp_change*-1)) end
            hp_change = 0
        else
            if morphinggrid.optional_dependencies["3d_armor"] then
                handle_3d_armor(player, hp_change, reason)
            end
            hp_change = get_multiplied_hp(player, hp_change)
            if morphinggrid.debug then morphinggrid.chat_send_admins("hpchange_demorphed: "..hp_change) end
        end
    end
    return hp_change
end, true)


--This function calculates the damage that will be done to the other ObjectRef that punches the player.
local get_multiplied_punchback = function(player, damage)
    local player_main = player:get_inventory():get_list("main")
    local morphers_main = morphinggrid.morphers.get_inventory(player):get_list("main")
    local morphers_single = morphinggrid.morphers.get_inventory(player):get_list("single")

    local sum = 0
    for _, stack in pairs(combine_tables(player_main, morphers_main, morphers_single)) do
        local griditemdef = morphinggrid.registered_griditems[stack:get_name()]
        local morpherdef = morphinggrid.registered_morphers[stack:get_name()]
        local punchback_multiplier = 0
        if griditemdef then
            if type(griditemdef.punchback_multiplier) == "number" then
                punchback_multiplier = griditemdef.punchback_multiplier
            elseif type(griditemdef.punchback_multiplier) == "function" then
                punchback_multiplier = griditemdef.punchback_multiplier(player, damage, sum, stack) or 0
            end
        elseif morpherdef then
            if type(morpherdef.punchback_multiplier) == "number" then
                punchback_multiplier = morpherdef.punchback_multiplier
            elseif type(morpherdef.punchback_multiplier) == "function" then
                punchback_multiplier = morpherdef.punchback_multiplier(player, damage, sum, stack) or 0
            end
        end
        sum = sum + (punchback_multiplier * damage)
    end

    return sum
end

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
    if hitter and damage > 0 then
        local punchback = get_multiplied_punchback(player, damage)
        if hitter:is_player() and get_multiplied_punchback(hitter, 1) <= 0 then
            if punchback > 0 then
                hitter:punch(player, 1, {damage_groups={fleshy=punchback}})
            end
        elseif not hitter:is_player() then
            hitter:punch(player, 1, {damage_groups={fleshy=punchback}})
        end
    end
end)

if morphinggrid.optional_dependencies["3d_armor"] then
    armor:register_on_update(function(player)
        morphinggrid.update_player_visuals(player)
    end)

    local armor_punch = armor.punch
    armor.punch = function(self, player, ...)
        if not morphinggrid.get_morph_status(player) then
            armor_punch(self, player, ...)
        end
    end
end

player_api.register_model("powerrangers_character.b3d", {
    animation_speed = 30,
    textures = {
        "character.png",
        "morphinggrid_armor_transparent.png",
        "morphinggrid_armor_transparent.png",
        "morphinggrid_armor_transparent.png"
    },
    animations = {
        stand = {x=0, y=79},
        lay = {x=162, y=166},
        walk = {x=168, y=187},
        mine = {x=189, y=198},
        walk_mine = {x=200, y=219},
        sit = {x=81, y=160},
    },
})

minetest.register_on_joinplayer(function(player)
    minetest.after(0.1, function()
        player_api.set_model(player, "powerrangers_character.b3d")
        morphinggrid.update_player_visuals(player)
    end)
end)

function morphinggrid.get_ranger_textures(player, ranger)
    if type(player) == "string" then player = minetest.get_player_by_name(player) end
    local def = morphinggrid.registered_rangers[ranger]
    local rtextures = def.rtextures
    if type(def.get_rtextures) == "function" then
        local override = def.get_rtextures(player, ranger)
        override.boots = override.boots or {}
        override.leggings = override.leggings or {}
        override.chestplate = override.chestplate or {}
        override.helmet = override.helmet or {}
        rtextures.boots.armor = override.boots.armor or rtextures.boots.armor
        rtextures.leggings.armor = override.leggings.armor or rtextures.leggings.armor
        rtextures.chestplate.armor = override.chestplate.armor or rtextures.chestplate.armor
        rtextures.helmet.armor = override.helmet.armor or rtextures.helmet.armor
        rtextures.helmet.armor_visor_mask = override.helmet.armor_visor_mask or rtextures.helmet.armor_visor_mask
    end
    return rtextures
end

local function get_powerups_textures(player, ranger)
    local sets = {}
    local powerupslist = morphinggrid.player_get_powerups_list(player)
    for _, powerup in pairs(powerupslist) do
        local textures = morphinggrid.get_powerup_textures(player, ranger, powerup)
        if not textures then
            textures = {
                boots = {},
                leggings = {},
                chestplate = {},
                helmet = {}
            }
        end
        table.insert(sets, textures)
    end
    return sets
end

local function add_texture(texture)
    if texture then
        return "^"..texture
    end
    return ""
end

function morphinggrid.update_player_visuals(player)
    local name = player:get_player_name()
    local ranger = morphinggrid.get_morph_status(player)
    local textures = player:get_properties().textures
    if ranger then
        local rangerdata = morphinggrid.get_rangerdata(player, ranger)
        local rangerdef = morphinggrid.registered_rangers[ranger or ""]
        local ranger_rtextures = morphinggrid.get_ranger_textures(player, ranger)
        local ranger_powerup_rtextures_sets = get_powerups_textures(player, ranger)
        local ranger_armor = "morphinggrid_armor_transparent.png"..
            "^"..ranger_rtextures.boots.armor..
            "^"..ranger_rtextures.leggings.armor..
            "^"..ranger_rtextures.chestplate.armor

        --apply rtextures of powerups
        for _, set in pairs(ranger_powerup_rtextures_sets) do
            ranger_armor = ranger_armor..add_texture(set.boots.armor)..
                add_texture(set.leggings.armor)..
                add_texture(set.chestplate.armor)
        end

        local apply_helmet = rangerdata:get_setting_value("helmet_state") == "on"
        local open_visor = rangerdata:get_setting_value("visor_state") == "opened" and
            type(ranger_rtextures.helmet.armor_visor_mask) == "string"

        if apply_helmet then
            ranger_armor = ranger_armor.."^"..ranger_rtextures.helmet.armor
            --apply helmet textures of powerups
            for _, set in pairs(ranger_powerup_rtextures_sets) do
                ranger_armor = ranger_armor..add_texture(set.helmet.armor)
            end
            if open_visor then
                ranger_armor = ranger_armor.."^[mask:"..ranger_rtextures.helmet.armor_visor_mask
            end
        end

        textures[4] = ranger_armor
    else
        textures[4] = "armor_transparent.png"
    end
    player_api.set_textures(player, textures)
end