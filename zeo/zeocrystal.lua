morphinggrid.register_griditem("zeo:zeo_crystal", {
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
	}
})

morphinggrid.register_griditem("zeo:zeo_crystal_1", {
  description = "Zeo Crystal 1",
  inventory_image = "zeo_crystal_1.png",
  groups = {not_in_creative_inventory=1},
})

morphinggrid.register_griditem("zeo:zeo_crystal_2", {
  description = "Zeo Crystal 2",
  inventory_image = "zeo_crystal_2.png",
  groups = {not_in_creative_inventory=1},
})

morphinggrid.register_griditem("zeo:zeo_crystal_3", {
  description = "Zeo Crystal 3",
  inventory_image = "zeo_crystal_3.png",
  groups = {not_in_creative_inventory=1},
})

morphinggrid.register_griditem("zeo:zeo_crystal_4", {
  description = "Zeo Crystal 4",
  inventory_image = "zeo_crystal_4.png",
  groups = {not_in_creative_inventory=1},
})

morphinggrid.register_griditem("zeo:zeo_crystal_5", {
  description = "Zeo Crystal 5",
  inventory_image = "zeo_crystal_5.png",
  groups = {not_in_creative_inventory=1},
})