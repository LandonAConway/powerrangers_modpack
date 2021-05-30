minetest.register_craft({
    type = "shapeless",
    output = "zeo:right_zeonizer",
    recipe = {"default:gold_ingot", "default:steel_ingot", "default:copper_ingot", "dye:red", "dye:white",
			"dye:black", "morphinggrid:standard_morpher_motherboard", "micro_energy_connector_unit"}
  })

minetest.register_craft({
    type = "shapeless",
    output = "zeo:left_zeonizer",
    recipe = {"default:gold_ingot", "default:steel_ingot", "default:copper_ingot", "dye:red", "dye:white", 
				"dye:black", "morphinggrid:standard_morpher_motherboard", "micro_energy_release_unit"}
  })
  
  minetest.register_craft({
    type = "shapeless",
    output = "zeo:zeo_crystal",
    recipe = {"zeo:zeo_crystal_1", "zeo:zeo_crystal_2", "zeo:zeo_crystal_3",
          "zeo:zeo_crystal_4", "zeo:zeo_crystal_5"}
  })