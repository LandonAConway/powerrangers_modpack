--armor extention method to update armor
function armor.morphinggrid_update_player_visuals(self, player)
    local name = player:get_player_name()
    local ranger = morphinggrid.get_morph_status(player)
    if ranger and self.textures[name] then
        local rangerdef = morphinggrid.registered_rangers[ranger]
        local armor = self.textures[name].armor

        --apply visor mask if visor is opened
        if ranger_settings:get_value_of_current(player, "visor_state") == "opened" then
            local armor_visor_mask = rangerdef.armor_textures.helmet.armor_visor_mask
            if type(armor_visor_mask) == "string" then
                armor = armor.."^[mask:"..armor_visor_mask
            end
        end

        player_api.set_textures(player, {
            self.textures[name].skin,
            armor,
            self.textures[name].wielditem,
        })
    end
end

armor:register_on_update(function(player)
    armor:morphinggrid_update_player_visuals(player)
end)