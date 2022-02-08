communicator.register_channel("beast_morphers", {
  description = "Beast Morphers",
  private_call_sign = "Wristcom",
  public_call_sign = "Beast_Morphers_Rangers"
})

local rangers = {
	red = { description = "Red" },
	yellow = { description = "Yellow" },
	blue = { description = "Blue" },
	silver = { description = "Silver" },
	gold = { description = "Gold" }
}

for k,v in pairs(rangers) do
	communicator.register_communicator("beast_morphers:wristcom_"..k, {
		description = v.description.." Wristcom (Beast Morphers)",
		inventory_image = "beast_morphers_wristcom.png",
		channel = "beast_morphers",
		ranger = "beast_morphers:"..k,

		communicator_command_presets = {
			basic = true,
		},
		
		grid_doc = {
			description = "Used to communicate with other players who have another Wristcom. Use chat command '/communicator help' "..
					"to see a list of commands."
		}
	})

	if mod_loaded("electronic_materials") then
		minetest.register_craft({
			type = "shapeless",
			output = "beast_morphers:wristcom_"..k,
			recipe = {
				"beast_morphers:ranger_key_"..k, "default:copper_ingot", "default:steel_ingot", 
				"electronic_materials:small_circuit_board", "electronic_materials:bios_chip"
		},
		replacements = {
				{"beast_morphers:ranger_key_"..k, "beast_morphers:ranger_key_"..k}
			}
		})
	else
		minetest.register_craft({
		type = "shapeless",
		output = "beast_morphers:wristcom_"..k,
		recipe = {
			"default:copper_ingot", "default:steel_ingot", "morphinggrid:standard_morpher_motherboard", "dye:white", "dye:black", 
			"dye:black", "beast_morphers:ranger_key_"..k
		},
		replacements = {
				{"beast_morphers:ranger_key_"..k, "beast_morphers:ranger_key_"..k}
			}
		})
	end
end