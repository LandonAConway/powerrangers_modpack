morphinggrid.register_powerup("morphin_masters:master_mode", {
    description = "Master Mode",
    mult_energy = 1.25,
    rtextures = {
        leggings = { armor = "morphin_masters_master_mode_leggings.png" },
        chestplate = { armor = "morphin_masters_master_mode_chestplate.png" }
    }
})

function morphin_masters.toggle_master_mode(player)
    if type(player) == "string" then player = minetest.get_player_by_name(player) end
    local is_powered_up = morphinggrid.player_check_powerups(player, {["morphin_masters:master_mode"]=true})
    if not is_powered_up then
        morphinggrid.powerup(player, "morphin_masters:master_mode")
    else
        morphinggrid.powerdown(player, "morphin_masters:master_mode")
    end
end

morphinggrid.register_griditem("morphin_masters:master_mode_key", {
    description = "Master Mode Key",
    inventory_image = "morphin_masters_master_mode_key.png",
	groups = {not_in_creative_inventory=1},
	prevents_respawn = true,
	hp_multiplier = 0.25,
	grid_doc = {
		description = "Allows morphed players to use the 'Master Mode' powerup."
	},
    on_use = function(itemstack, user, pointed_thing)
        morphin_masters.toggle_master_mode(user)
    end
})
