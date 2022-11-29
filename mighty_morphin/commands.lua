minetest.register_chatcommand("give_dragon_shield", {
	params = "<player>",
	description = "Transfers the Dragon Shield to another ranger if you currently have it.",
	
	privs = {
		interact = true,
		power_rangers = true,
	},
	
	func = function(name, text)
		local from = minetest.get_player_by_name(name)
		local to = minetest.get_player_by_name(text)
		
		if text ~= nil and text ~= "" then
			if minetest.player_exists(text) then
				if to ~= nil then
					return mighty_morphin.give_dragon_shield(from, to)
				end
				return false, text.." is not online."
			end
			return false, "Player "..text.." does not exist."
		end
		return false, "Invalid Usage. Enter a player name."
	end,
})

minetest.register_chatcommand("dragon_shield", {
	params = "",
	description = "Summons the Dragon Shield if you have the Dragonzord power coin. If you are using it, it will go away.",
	
	privs = {
		interact = true,
		power_rangers = true,
	},
	
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		return mighty_morphin.summon_dragon_shield(player)
	end,
})