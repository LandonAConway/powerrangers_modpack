minetest.register_craft({
    type = "shapeless",
    output = "zeo:right_zeonizer",
    recipe = {"default:gold_ingot", "default:steel_ingot", "default:copper_ingot", "dye:red", "dye:white",
			"dye:black", "morphinggrid:standard_morpher_motherboard", "morphinggrid:micro_energy_reader_unit"}
  })

minetest.register_craft({
    type = "shapeless",
    output = "zeo:left_zeonizer",
    recipe = {"default:gold_ingot", "default:steel_ingot", "default:copper_ingot", "dye:red", "dye:white", 
				"dye:black", "morphinggrid:standard_morpher_motherboard", "morphinggrid:micro_energy_release_unit"}
  })
  
  minetest.register_craft({
    type = "shapeless",
    output = "zeo:zeo_crystal",
    recipe = {"zeo:zeo_crystal_1", "zeo:zeo_crystal_2", "zeo:zeo_crystal_3",
          "zeo:zeo_crystal_4", "zeo:zeo_crystal_5"}
  })
  
--zeo crystals
local zeo_crystals = {
	{ "pink" },
	{ "yellow" },
	{ "blue" },
	{ "green" },
	{ "red" }
}

for i, r in pairs(zeo_crystals) do
	minetest.register_craft({
		type = "shapeless",
		output = "zeo:zeo_crystal_"..i,
		recipe = {"morphinggrid:energy", "morphinggrid:energy", "morphinggrid:energy",
				"morphinggrid:energy", "default:glass", "zeo:"..r[1].."_rangerdata" }
	})
end

minetest.register_craft({
	type = "shapeless",
	output = "zeo:gold_staff",
	recipe = {"morphinggrid:energy", "morphinggrid:energy", "morphinggrid:energy",
			"morphinggrid:energy", "default:gold_ingot", "default:gold_ingot",
			"default:gold_ingot", "default:gold_ingot", "zeo:gold_rangerdata" }
})