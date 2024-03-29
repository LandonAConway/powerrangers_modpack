morphinggrid.ranger_cmd_presets.default = {
	toggle_helmet = {
		short = "tgh",
		description = "Toggles a ranger's helmet.",
		func = function(name, text, ranger)
			local player = minetest.get_player_by_name(name)
			local helmet_state = ranger_settings:get_value(player, ranger, "helmet_state")
			if helmet_state == "off" then
				helmet_state = "on"
			else
				helmet_state = "off"
			end
			ranger_settings:set_value(player, ranger, "helmet_state", helmet_state)
			morphinggrid.update_player_visuals(player)
		end
	},

	chat = {
		short = "c",
		description = "Say something public without revealing your ranger identity.",
		func = function(name, text, ranger)
			if text ~= nil and text ~= "" then
				local ranger_desc = morphinggrid.registered_rangers[ranger].description or ranger
				minetest.chat_send_all("<"..ranger_desc.."> "..(text or ""))
			end
		end
	}
}