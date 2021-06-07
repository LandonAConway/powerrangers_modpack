morphinggrid.register_griditem("morphinggrid:energy", {
	description = "Morphing Grid Energy",
	inventory_image = "morphinggrid_energy.png",
	groups = {not_in_creative_inventory=1},
	grid_doc = {
		description = "Morphing Grid Energy can be used to craft some items. It gives the power used to attach objects to the Morphing Grid."
	}
})

minetest.register_craftitem("morphinggrid:micro_energy_release_unit", {
	description = "Micro Morphing Grid Energy Release Unit",
	inventory_image = "energy_release_micro_unit_releaser.png",
	grid_doc = {
		description = "Releases Morphing Grid Energy data from a morpher."
	}
})

minetest.register_craftitem("morphinggrid:micro_energy_reader_unit", {
	description = "Micro Morphing Grid Energy Reader Unit",
	inventory_image = "energy_release_micro_unit_reader.png",
	grid_doc = {
		description = "Reads objects attached to the Morphing Grid."
	}
})

minetest.register_craftitem("morphinggrid:standard_morpher_motherboard", {
	description = "Standard Morpher Motherboard",
	inventory_image = "morpher_mother_board.png"
})