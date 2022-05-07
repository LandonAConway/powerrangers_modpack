morphinggrid.ranger_cmd_presets.visor = {
	toggle_visor = {
		description = "Toggles a ranger's visor.",
		func = function(name, text, ranger)
			local player = minetest.get_player_by_name(name)
			local visor_state = ranger_settings:get_value(player, ranger, "visor_state")
			if visor_state == "closed" then
				visor_state = "opened"
			else
				visor_state = "closed"
			end
			ranger_settings:set_value(player, ranger, "visor_state", visor_state)
			morphinggrid.update_player_visuals(player)
		end
	}
}