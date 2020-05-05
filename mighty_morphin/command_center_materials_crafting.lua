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