if minetest.get_modpath("electronic_materials") then

  minetest.register_craft({
    type = "shapeless",
    output = "morphinggrid:micro_energy_release_unit",
    recipe = {"electronic_materials:small_circuit_board", "electronic_materials:small_motherboard", "electronic_materials:molten_copper",
              "dye:black", "default:diamond" }
  })
  
   minetest.register_craft({
    type = "shapeless",
    output = "morphinggrid:micro_energy_reader_unit",
    recipe = {"electronic_materials:small_circuit_board", "electronic_materials:small_motherboard", "electronic_materials:molten_copper",
              "dye:black", "default:diamond", "default:mese_crystal" }
  })
  
  minetest.register_craft({
    type = "shapeless",
    output = "morphinggrid:standard_morpher_motherboard",
    recipe = {"electronic_materials:small_circuit_board", "morphinggrid:micro_energy_release_unit", "electronic_materials:bios_chip",
              "electronic_materials:sd_card_32gb", "default:diamond" }
  })
  
else
	minetest.register_craft({
		type = "shapeless",
		output = "morphinggrid:micro_energy_release_unit",
		recipe = {
			"default:copper_ingot", "default:copper_ingot", "dye:black", "dye:white", "default:mese_crystal",
			"default:diamond"
		}
	})
	
	minetest.register_craft({
		type = "shapeless",
		output = "morphinggrid:micro_energy_reader_unit",
		recipe = {
			"default:copper_ingot", "default:copper_ingot", "default:steel", "dye:black", "dye:white",
			"default:mese_crystal", "default:diamond"
		}
	})
	
	minetest.register_craft({
		type = "shapeless",
		output = "morphinggrid:standard_morpher_motherboard",
		recipe = {
			"default:copper_ingot", "default:copper_ingot", "dye:dark_green", "dye:white", "default:mese_crystal"
		}
	})
	
end