morphinggrid.griditem_cmd_presets.bond_dna = {
	bond = {
		description = "Bonds the griditem to a player. This cannot be undone.",
		func = function(name, text, itemstack)
			local itemstack = morphinggrid.bond_item_to_player(minetest.get_player_by_name(name))
			if itemstack then
				return true, "The Grid Item has bonded to you", itemstack
			end
			return false, "The Grid Item has not bonded to you because it already has bonded to another player."
		end
	}
}