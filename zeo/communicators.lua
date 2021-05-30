communicator.register_channel("zeo", {
	description = "Zeo",
	private_call_sign = "Communicator",
	public_call_sign = "Zeo_Rangers"
})

for i,v in ipairs(zeo.rangers) do
	communicator.register_communicator("zeo:wrist_communicator_"..v[1], {
		description = v[2].." Wrist Communicator",
		inventory_image = "wrist_communicator_"..v[1]..".png",
		channel = "zeo",
		ranger = "zeo:"..v[1],
		teleportation = true,
		groups = {teleportation=1},

		communicator_command_presets = {
			basic = true,
			teleportation = true
		}
	})

	minetest.register_craft({
		type = "shapeless",
		output = "zeo:wrist_communicator_"..v[1],
		recipe = {
			"default:copper_ingot", "default:steel_ingot", "morphinggrid:standard_morpher_motherboard", "dye:"..v[1], "dye:white", 
			"dye:black", "zeo:zeo_crystal_"..i
		},
		replacements = {
			{ "zeo:zeo_crystal_"..i, "zeo:zeo_crystal_"..i }
		}
	})
end