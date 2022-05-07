--prevents the player from having their hp change when morphed, instead affects the ranger armor
local handle_3d_armor = function(player, hp_change, reason)
    if player and reason.type ~= "drown" and reason.hunger == nil then
        local name = player:get_player_name()
        if name then
            local heal = armor.def[name].heal
            if heal >= math.random(100) then
                hp_change = 0
            end
        end
    end
    return hp_change
end

minetest.register_on_player_hpchange(function(player, hp_change, reason)
    if hp_change < 0 then
        if morphinggrid.get_morph_status(player) then
            morphinggrid.get_current_rangerdata(player):damage_energy(hp_change*-1)
            morphinggrid.hud_update_power_usage(player)
            hp_change = 0
        else
            hp_change = handle_3d_armor(player, hp_change, reason)
        end
    end
    return hp_change
end, true)

function morphinggrid.update_player_visuals(player)
    local name = player:get_player_name()
    local ranger = morphinggrid.get_morph_status(player)
    local textures = player:get_properties().textures
    if ranger then
        local rangerdata = morphinggrid.get_current_rangerdata(player)
        local rangerdef = morphinggrid.registered_rangers[ranger or ""]
        local ranger_armor_textures = rangerdef.armor_textures
        local ranger_armor = "armor_transparent.png"..
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