morphinggrid.register_griditem("zeo:zeo_crystal", {
	description = "Zeo Crystal",
	type = "node",
	tiles = {
		"zeo_crystal.png",
		"zeo_crystal.png",
		"zeo_crystal.png",
		"zeo_crystal.png",
		"zeo_crystal.png",
		"zeo_crystal.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	light_source = 10,
	use_texture_alpha = true,
	inventory_image = "zeo_crystal_inv.png",
	prevents_respawn = true,
	rangers = { "zeo:pink", "zeo:yellow", "zeo:blue", "zeo:green", "zeo:red", "zeo:gold" },
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.125, 0.0625, 0.125, 0},
			{-0.125, -0.5, 0, 0.125, -0.125, 0.125},
			{-0.1875, -0.5, -0.1875, -0, -0.0625, 0},
			{0.0625, -0.5, -0.125, 0.1875, -0.0625, 0},
			{-0, -0.5, -0.25, 0.125, -0.1875, -0.125},
		}
	},
	groups = { cracky = 50 },
	drop = {
	   max_items = 5,
	   items = {
	       {
	           items = { 'zeo:zeo_crystal_1', 'zeo:zeo_crystal_2', 'zeo:zeo_crystal_3', 'zeo:zeo_crystal_4', 'zeo:zeo_crystal_5' },
	           rarity = 1
	       },
	   },
	},
	grid_doc = {
		description = "The Zeo Crystal holds an immense amount of power, and provides the zeo rangers with their powers. "..
			"The Zeo Crystal can only be broken (dug) by certian items/weapons. Digging it will provide the Zeo "..
			"Sub Crystals while crafting the Zeo Sub Crystals will create the Zeo Crystal again."
	}
})

morphinggrid.register_griditem("zeo:zeo_crystal_1", {
  description = "Zeo Sub Crystal 1",
  inventory_image = "zeo_crystal_1.png",
  groups = {not_in_creative_inventory=1},
  rangers = { "zeo:pink" },
  morph_chance = 14,
  prevents_respawn = true,
  grid_doc = {
	description = "The Zeo Sub Crystal 1 provides powers for Zeo Ranger 1, Pink."
  }
})

morphinggrid.register_griditem("zeo:zeo_crystal_2", {
  description = "Zeo Sub Crystal 2",
  inventory_image = "zeo_crystal_2.png",
  groups = {not_in_creative_inventory=1},
  rangers = { "zeo:yellow" },
  morph_chance = 14,
  prevents_respawn = true,
  grid_doc = {
	description = "The Zeo Sub Crystal 1 provides powers for Zeo Ranger 2, Yellow."
  }
})

morphinggrid.register_griditem("zeo:zeo_crystal_3", {
  description = "Zeo Sub Crystal 3",
  inventory_image = "zeo_crystal_3.png",
  groups = {not_in_creative_inventory=1},
  rangers = { "zeo:blue" },
  morph_chance = 14,
  prevents_respawn = true,
  grid_doc = {
	description = "The Zeo Sub Crystal 1 provides powers for Zeo Ranger 3, Blue."
  }
})

morphinggrid.register_griditem("zeo:zeo_crystal_4", {
  description = "Zeo Sub Crystal 4",
  inventory_image = "zeo_crystal_4.png",
  groups = {not_in_creative_inventory=1},
  rangers = { "zeo:green" },
  morph_chance = 14,
  prevents_respawn = true,
  grid_doc = {
	description = "The Zeo Sub Crystal 1 provides powers for Zeo Ranger 4, Green."
  }
})

morphinggrid.register_griditem("zeo:zeo_crystal_5", {
  description = "Zeo Sub Crystal 5",
  inventory_image = "zeo_crystal_5.png",
  groups = {not_in_creative_inventory=1},
  rangers = { "zeo:red" },
  morph_chance = 14,
  prevents_respawn = true,
  grid_doc = {
	description = "The Zeo Sub Crystal 1 provides powers for Zeo Ranger 5, Red."
  }
})