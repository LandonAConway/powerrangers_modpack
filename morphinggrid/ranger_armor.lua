--prevents the player from having their hp change when morphed, instead affects the ranger armor
local handle_3d_armor = function(player, hp_change, reason)
    if player and reason.type ~= "drown" and reason.hunger == nil then
        local name = player:get_player_name()
        if name then
            math.randomseed(os.time)
            local heal = armor.def[name].heal
            if heal >= math.random(100) then
                hp_change = 0
            end
        end
    end
    return hp_change
end

local load_armor = function(player)
    local player_name = player:get_player_name()
    local inv = minetest.get_inventory({
        type="detached", name=player_name.."_armor"})
    local list = {}
    if inv then
        for _, stack in pairs(minetest.deserialize(player:get_meta():get_string("3d_armor_inv_list")) or {}) do
            table.insert(list, ItemStack(stack))
        end
    end
    inv:set_list("armor", list)
end

local save_armor = function(player)
    local player_name = player:get_player_name()
    local inv = minetest.get_inventory({
        type="detached", name=player_name.."_armor"})
    local list = {}
    if inv then
        for _, stack in pairs(inv:get_list("armor")) do
            table.insert(list, stack:to_table())
        end
    end
    player:get_meta():set_string("3d_armor_inv_list", minetest.serialize(list))
end

minetest.register_on_player_hpchange(function(player, hp_change, reason)
    if hp_change < 0 then
        if morphinggrid.get_morph_status(player) then
            morphinggrid.get_current_rangerdata(player):damage_energy_hp(hp_change*-1)
            morphinggrid.hud_update_power_usage(player)
            hp_change = 0
            if morphinggrid.optional_dependencies["3d_armor"] then
                load_armor(player)
            end
        else
            if morphinggrid.optional_dependencies["3d_armor"] then
                hp_change = handle_3d_armor(player, hp_change, reason)
            end
        end
        save_armor(player)
    end
    return hp_change
end, true)

if morphinggrid.optional_dependencies["3d_armor"] then
    armor:register_on_update(function(player)
        morphinggrid.update_player_visuals(player)
    end)

    armor:register_on_equip(function(player, index, stack)
        save_armor(player)
    end)

    armor:register_on_unequip(function(player, index, stack)
        save_armor(player)
    end)
else
    default.player_register_model("3d_armor_character.b3d", {
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
        player_api.set_model(player, "3d_armor_character.b3d")
        morphinggrid.update_player_visuals(player)
    end)
end

function morphinggrid.update_player_visuals(player)
    local name = player:get_player_name()
    local ranger = morphinggrid.get_morph_status(player)
    local textures = player:get_properties().textures
    if ranger then
        local rangerdata = morphinggrid.get_current_rangerdata(player)
        local rangerdef = morphinggrid.registered_rangers[ranger or ""]
        local ranger_armor_textures = rangerdef.armor_textures
        local ranger_armor = "morphinggrid_armor_transparent.png"..
            "^"..ranger_armor_textures.boots.armor..
            "^"..ranger_armor_textures.leggings.armor..
            "^"..ranger_armor_textures.chestplate.armor

        local apply_helmet = rangerdata:get_setting_value("helmet_state") == "on"
        local open_visor = rangerdata:get_setting_value("visor_state") == "opened" and
            type(ranger_armor_textures.helmet.armor_visor_mask) == "string"

        if apply_helmet then
            ranger_armor = ranger_armor.."^"..ranger_armor_textures.helmet.armor
            if open_visor then
                ranger_armor = ranger_armor.."^[mask:"..ranger_armor_textures.helmet.armor_visor_mask
            end
        end

        textures[4] = ranger_armor
    else
        textures[4] = "armor_transparent.png"
    end
    player_api.set_textures(player, textures)
end