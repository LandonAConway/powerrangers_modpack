morphinggrid.register_griditem("morphinggrid:energy", {
	description = "Morphing Grid Energy",
	stack_max = 65535,
	inventory_image = "morphinggrid_energy.png",
	groups = {not_in_creative_inventory=1},
	grid_doc = {
		other_item = true,
		description = "Morphing Grid Energy can be used to craft some items. It gives the power used to attach objects to the Morphing Grid."
	},
	on_use = function(itemstack, user, pointed_thing)
		if morphinggrid.get_morph_status(user) then
			local rdata = morphinggrid.get_current_rangerdata(user)
			rdata:add_energy(25)
			morphinggrid.hud_update_power_usage(user)
			itemstack:set_count(itemstack:get_count()-1)
		end
		return itemstack
	end
})

minetest.register_craftitem("morphinggrid:micro_energy_release_unit", {
	description = "Micro Morphing Grid Energy Release Unit",
	inventory_image = "energy_release_micro_unit_releaser.png",
	grid_doc = {
		other_item = true,
		description = "Utilizes the data recieved by the Reader Unit to make a morph happen."
	}
})

minetest.register_craftitem("morphinggrid:micro_energy_reader_unit", {
	description = "Micro Morphing Grid Energy Reader Unit",
	inventory_image = "energy_release_micro_unit_reader.png",
	grid_doc = {
		other_item = true,
		description = "Reads objects attached to the Morphing Grid (Grid Items)."
	}
})

minetest.register_craftitem("morphinggrid:standard_morpher_motherboard", {
	description = "Standard Morpher Motherboard",
	inventory_image = "morpher_mother_board.png",
	grid_doc = {
		other_item = true,
		description = "Connects the morphers hardware to it's software."
	}
})