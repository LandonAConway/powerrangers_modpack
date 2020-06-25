minetest.register_craft({
	type = "shaped",
	output = "mighty_morphin:zordon_tube",
	recipe = {
			{"morphinggrid:energy", "morphinggrid:energy", "morphinggrid:energy"},
			{"morphinggrid:energy", "default:glass", "morphinggrid:energy"},
			{"morphinggrid:energy", "morphinggrid:energy", "morphinggrid:energy"}
		}
})

minetest.register_craft({
	type = "shaped",
	output = "mighty_morphin:command_center_tube",
	recipe = {
			{"default:torch", "default:glass", ""},
			{"default:glass", "default:torch", ""},
			{"", "", ""}
		}
})

minetest.register_craft({
	type = "shaped",
	output = "mighty_morphin:command_center_wall_light",
	recipe = {
			{"mighty_morphin:command_center_tube", "default:clay_lump", ""},
			{"default:clay_lump", "mighty_morphin:command_center_tube", ""},
			{"", "", ""}
		}
})

minetest.register_craft({
	type = "shaped",
	output = "mighty_morphin:command_center_rail",
	recipe = {
			{"default:steel_ingot", "dye:dark_grey", "default:steel_ingot"},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
			{"default:steel_ingot", "dye:dark_grey", "default:steel_ingot"}
		}
})

minetest.register_craft({
	type = "shapeless",
	output = "mighty_morphin:command_center_rail_corner",
	recipe = {"mighty_morphin:command_center_rail", "mighty_morphin:command_center_rail"},
})

minetest.register_craft({
	type = "shaped",
	output = "mighty_morphin:command_center_counter",
	recipe = {
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
			{"default:steel_ingot", "dye:dark_grey", "default:steel_ingot"},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
		}
})

minetest.register_craft({
	type = "shapeless",
	output = "mighty_morphin:command_center_teleportation_computer",
	recipe = {"mighty_morphin:command_center_counter", "morphinggrid:energy",
	"default:steel_ingot"},
})