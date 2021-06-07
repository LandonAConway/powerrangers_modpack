morphinggrid.morpher_cmd_presets.bond_dna = {
	lock = {
		description = "Locks the morpher to a player.",
		func = function(name, text, itemstack)
			local itemstack = morphinggrid.lock_item_to_player(minetest.get_player_by_name(name), itemstack)
			if itemstack then
				return true, "The Morpher has locked to you", itemstack
			end
			return false, "The Morpher has not locked to you because it already has been locked to another player."
		end
	},
	
	unlock = {
		description = "Unlocks the morpher from a player.",
		func = function(name, text, itemstack)
			local itemstack = morphinggrid.unlock_item_from_player(minetest.get_player_by_name(name), itemstack)
			if itemstack then
				return true, "The Morpher has been unlocked.", itemstack
			end
			return false, "The Morpher has not been unlocked because it has been locked to another player."
		end
	}
}