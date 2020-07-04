if mod_loaded("electronic_materials") then

  minetest.register_craft({
    type = "shapeless",
    output = "morphinggrid:micro_energy_connector_release_unit",
    recipe = {"electronic_materials:small_circuit_board", "electronic_materials:small_motherboard", "electronic_materials:molten_copper",
              "dye:black" }
  })
  
  minetest.register_craft({
    type = "shapeless",
    output = "morphinggrid:standard_morpher_motherboard",
    recipe = {"electronic_materials:small_circuit_board", "morphinggrid:micro_energy_connector_release_unit", "electronic_materials:bios_chip",
              "electronic_materials:sd_card_32gb" }
  })
  
end