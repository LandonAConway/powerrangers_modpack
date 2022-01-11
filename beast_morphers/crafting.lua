minetest.register_craft({
  output = "beast_morphers:morpher",
  type = "shapeless",
  recipe = { "beast_morphers:test_tube_morphx", "default:steel_ingot", "default:copper_ingot", "vessels:glass_fragments", "dye:black", "dye:blue", "dye:yellow" }
})

minetest.register_craft({
  output = "beast_morphers:morphx_drum",
  type = "shaped",
  recipe = {
    { "basic_materials:plastic_sheet", "dye:blue", "basic_materials:plastic_sheet" },
    { "basic_materials:plastic_sheet", "dye:blue", "basic_materials:plastic_sheet" },
    { "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" }
  }
})

minetest.register_craft({
  output = "beast_morphers:morphx_source",
  type = "shaped",
  recipe = {
    { "morphinggrid:energy", "morphinggrid:energy", "morphinggrid:energy" },
    { "morphinggrid:energy", "dye:green", "morphinggrid:energy" },
    { "morphinggrid:energy", "morphinggrid:energy", "morphinggrid:energy" }
  }
})

minetest.register_craft({
  output = "beast_morphers:morphx_source",
  type = "shapeless",
  recipe = { "beast_morphers:morphx_drum" }
})

minetest.register_craft({
  output = "beast_morphers:test_tube_empty 2",
  type = "shaped",
  recipe = {
    { "vessles:glass_fragments", "", "" },
    { "vessles:glass_fragments", "", "" },
    { "", "", "" }
  }
})

minetest.register_craft({
  output = "beast_morphers:flask_empty 2",
  type = "shaped",
  recipe = {
    { "vessels:glass_fragments", "", "vessels:glass_fragments" },
    { "", "vessels:glass_fragments", "" },
    { "", "", "" }
  }
})