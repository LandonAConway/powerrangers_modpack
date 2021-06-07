communicator.register_channel("zeo", {
	description = "Zeo",
	private_call_sign = "Communicator",
	public_call_sign = "Zeo_Rangers"
})

local zeo_rangers = zeo.rangers

for i,v in ipairs(zeo.rangers) do
	communicator.register_communicator("zeo:wrist_communicator_"..v[1], {
		description = v[2].." Wrist Communicator (Zeo)",
		inventory_image = "wrist_communicator_"..v[1]..".png",
		channel = "zeo",
		ranger = "zeo:"..v[1],
		teleportation = true,
		groups = {teleportation=1},

		communicator_command_presets = {
			basic = true,
			teleportation = true
		},
		
		grid_doc = {
			description = "Used to communicate with other players who have another Zeo communicator. Use chat command '/communicator help' "..
					"to see a list of commands."
		}
	})
	
	if mod_loaded("electronic_materials") then
		minetest.register_craft({
			type = "shapeless",
			output = "zeo:wrist_communicator_"..v[1],
			recipe = {
				"zeo:zeo_crystal_"..i, "default:copper_ingot", "default:steel_ingot", 
				"electronic_materials:small_circuit_board", "electronic_materials:bios_chip"
			},
			
			replacements = {
				{ "zeo:zeo_crystal_"..i, "zeo:zeo_crystal_"..i }
			}
		})
	else
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
end

communicator.register_communicator("zeo:wrist_communicator_gold", {
	description = "Gold Wrist Communicator (Zeo)",
	inventory_image = "wrist_communicator_gold.png",
	channel = "zeo",
	ranger = "zeo:gold",
	teleportation = true,
	groups = {teleportation=1},

	communicator_command_presets = {
		basic = true,
		teleportation = true
	},
	
	grid_doc = {
		description = "Used to communicate with other players who have another Zeo communicator. Use chat command '/communicator help' "..
				"to see a list of commands."
	}
})

if mod_loaded("electronic_materials") then
	minetest.register_craft({
		type = "shapeless",
		output = "zeo:wrist_communicator_gold",
		recipe = {
			"zeo:gold_staff", "default:copper_ingot", "default:steel_ingot", 
			"electronic_materials:small_circuit_board", "electronic_materials:bios_chip"
		},
		
		replacements = {
			{ "zeo:gold_staff", "zeo:gold_staff" }
		}
	})
else
	minetest.register_craft({
		type = "shapeless",
		output = "zeo:wrist_communicator_gold",
		recipe = {
			"default:copper_ingot", "default:steel_ingot", "morphinggrid:standard_morpher_motherboard", "default:gold_ingot", "dye:white", 
			"dye:black", "zeo:gold_staff"
		},
		
		replacements = {
			{ "zeo:gold_staff", "zeo:gold_staff" }
		}
	})
end