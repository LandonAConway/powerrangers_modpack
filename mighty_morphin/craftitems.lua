morphinggrid.register_morpher("mighty_morphin:empty_morpher", {
	type = "craftitem",
	description = "Empty Morpher",
	inventory_image = "emptymorpher.png",
	groups = {not_in_creative_inventory=1, morpher=1},
	has_connection = false,
	
	grid_doc = {
		description = "An empty Mighty Morphin morpher. You can input any Power Coin into it's slots to get a specific morpher "..
		"(Use chat command '/morpher slots' when wielding it)."
	},
	
	morpher_slots = {
		amount = 1,
		load_input = function(morpher)
			return true, {}
		end,
		
		output = function(morpher, slots)
			if slots[1]:get_name() == "mighty_morphin:tigerzord_powercoin" then
				return true, ItemStack("mighty_morphin:tigerzord_morpher")
			elseif slots[1]:get_name() == "mighty_morphin:dragonzord_powercoin" then
				return true, ItemStack("mighty_morphin:dragonzord_morpher")
			elseif slots[1]:get_name() == "mighty_morphin:mastodon_powercoin" then
				return true, ItemStack("mighty_morphin:mastodon_morpher")
			elseif slots[1]:get_name() == "mighty_morphin:pterodactyl_powercoin" then
				return true, ItemStack("mighty_morphin:pterodactyl_morpher")
			elseif slots[1]:get_name() == "mighty_morphin:triceratops_powercoin" then
				return true, ItemStack("mighty_morphin:triceratops_morpher")
			elseif slots[1]:get_name() == "mighty_morphin:saber_toothed_tiger_powercoin" then
				return true, ItemStack("mighty_morphin:saber_toothed_tiger_morpher")
			elseif slots[1]:get_name() == "mighty_morphin:tyrannosaurus_powercoin" then
				return true, ItemStack("mighty_morphin:tyrannosaurus_morpher")
			end
			return false, morpher
		end,
		
		allow_put = function(morpher, itemstack)
			if itemstack:get_name() == "mighty_morphin:tigerzord_powercoin" or
			itemstack:get_name() == "mighty_morphin:dragonzord_powercoin" or
			itemstack:get_name() == "mighty_morphin:mastodon_powercoin" or
			itemstack:get_name() == "mighty_morphin:pterodactyl_powercoin" or
			itemstack:get_name() == "mighty_morphin:triceratops_powercoin" or
			itemstack:get_name() == "mighty_morphin:saber_toothed_tiger_powercoin" or
			itemstack:get_name() == "mighty_morphin:tyrannosaurus_powercoin" then
				return 1
			end
			return 0
		end,
		
		grid_doc = {
			inputs = {
				{ input = {"mighty_morphin:tigerzord_powercoin"} },
				{ input = {"mighty_morphin:dragonzord_powercoin"} },
				{ input = {"mighty_morphin:mastodon_powercoin"} },
				{ input = {"mighty_morphin:pterodactyl_powercoin"} },
				{ input = {"mighty_morphin:triceratops_powercoin"} },
				{ input = {"mighty_morphin:saber_toothed_tiger_powercoin"} },
				{ input = {"mighty_morphin:tyrannosaurus_powercoin"} },
			}
		}
	},
})

morphinggrid.register_griditem("mighty_morphin:mastodon_powercoin", {
	description = "Mastodon Power Coin",
	inventory_image = "mastodon_powercoin.png",
	groups = {not_in_creative_inventory=1},
	rangers = { "mighty_morphin:black" },
	morph_chance = 8,
	prevents_respawn = true,
	hp_multiplier = 0.5,
	grid_doc = {
		description = "Holds the power of the Mighty Morphin Black Ranger."
	}
})
morphinggrid.register_griditem("mighty_morphin:pterodactyl_powercoin", {
	description = "Pterodactyl Power Coin",
	inventory_image = "pterodactyl_powercoin.png",
	groups = {not_in_creative_inventory=1},
	prevents_respawn = true,
	rangers = { "mighty_morphin:pink" },
	morph_chance = 8,
	hp_multiplier = 0.5,
	grid_doc = {
		description = "Holds the power of the Mighty Morphin Pink Ranger."
	}
})
morphinggrid.register_griditem("mighty_morphin:triceratops_powercoin", {
	description = "Triceratops Power Coin",
	inventory_image = "triceratops_powercoin.png",
	groups = {not_in_creative_inventory=1},
	prevents_respawn = true,
	rangers = { "mighty_morphin:blue" },
	morph_chance = 8,
	hp_multiplier = 0.5,
	grid_doc = {
		description = "Holds the power of the Mighty Morphin Blue Ranger."
	}
})
morphinggrid.register_griditem("mighty_morphin:saber_toothed_tiger_powercoin", {
	description = "Saber-Toothed Tiger Power Coin",
	inventory_image = "saber_toothed_tiger_powercoin.png",
	groups = {not_in_creative_inventory=1},
	prevents_respawn = true,
	rangers = { "mighty_morphin:yellow" },
	morph_chance = 8,
	hp_multiplier = 0.5,
	grid_doc = {
		description = "Holds the power of the Mighty Morphin Yellow Ranger."
	}
})
morphinggrid.register_griditem("mighty_morphin:tyrannosaurus_powercoin", {
	description = "Tyrannosaurus Power Coin",
	inventory_image = "tyrannosaurus_powercoin.png",
	groups = {not_in_creative_inventory=1},
	prevents_respawn = true,
	rangers = { "mighty_morphin:red" },
	morph_chance = 8,
	hp_multiplier = 0.5,
	grid_doc = {
		description = "Holds the power of the Mighty Morphin Red Ranger."
	}
})
morphinggrid.register_griditem("mighty_morphin:dragonzord_powercoin", {
	description = "Dragonzord Power Coin",
	inventory_image = "dragonzord_powercoin.png",
	groups = {not_in_creative_inventory=1},
	prevents_respawn = true,
	rangers = { "mighty_morphin:green" },
	morph_chance = 8,
	hp_multiplier = 0.5,
	grid_doc = {
		description = "Holds the power of the Mighty Morphin Green Ranger."
	}
})
morphinggrid.register_griditem("mighty_morphin:tigerzord_powercoin", {
	description = "Tigerzord Power Coin",
	inventory_image = "tigerzord_powercoin.png",
	groups = {not_in_creative_inventory=1},
	prevents_respawn = true,
	rangers = { "mighty_morphin:white" },
	morph_chance = 8,
	hp_multiplier = 0.5,
	grid_doc = {
		description = "Holds the power of the Mighty Morphin White Ranger."
	}
})