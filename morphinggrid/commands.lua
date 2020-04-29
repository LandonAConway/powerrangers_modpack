minetest.register_chatcommand("demorph", {
	params = "",
	description = "Demorph",
	
	privs = {
		interact = true,
	},
	
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if morphinggrid.demorph(player, false) == true
		then
			return true, "You have successfuly demorphed."
		end
	end,
})