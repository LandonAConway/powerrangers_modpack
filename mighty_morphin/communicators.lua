communicator.register_channel("mighty_morphin", {
  description = "Mighty Morphin",
  private_call_sign = "Communicator",
  public_call_sign = "Mighty_Morphin_Rangers"
})

for i,v in ipairs(mmprrangers) do
	communicator.register_communicator("mighty_morphin:wrist_communicator_"..v[1], {
		description = v[2].." Wrist Communicator",
		inventory_image = "wrist_communicator_"..v[1]..".png",
		channel = "mighty_morphin",
		ranger = "mighty_morphin:"..v[1],
		teleportation = true,
		groups = { teleportation=1 },

		communicator_command_presets = {
			basic = true,
			teleportation = true
		}
	})

	if mod_loaded("electronic_materials") then
		minetest.register_craft({
			type = "shapeless",
			output = "mighty_morphin:wrist_communicator_"..v[1],
			recipe = {
				"mighty_morphin:"..v[5].."_powercoin", "default:copper_ingot", "default:steel_ingot", 
				"electronic_materials:small_circuit_board", "electronic_materials:bios_chip"
		},
		replacements = {
				{"mighty_morphin:"..v[5].."_powercoin", "mighty_morphin:"..v[5].."_powercoin"}
			}
		})
	else
		minetest.register_craft({
		type = "shapeless",
		output = "zeo:wrist_communicator_"..v[1],
		recipe = {
			"default:copper_ingot", "default:steel_ingot", "morphinggrid:standard_morpher_motherboard", "dye:"..v[1], "dye:white", 
			"dye:black", "mighty_morphin:"..v[5].."_powercoin"
		},
		replacements = {
				{"mighty_morphin:"..v[5].."_powercoin", "mighty_morphin:"..v[5].."_powercoin"}
			}
		})
	end
end