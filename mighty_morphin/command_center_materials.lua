minetest.register_node("mighty_morphin:zordon_tube", {
		description = "Zordon Tube",
		tiles = {"glass_no_edge.png", "zordon_tube.png"},
		drawtype = "glasslike_framed",
    		inventory_image = minetest.inventorycube("zordon_tube_inv.png"),

    		paramtype = "light",
			light_source = 8,
    		sunlight_propagates = true,
    		is_ground_content = false,

    		groups = {cracky = 3, oddly_breakable_by_hand = 3},
			use_texture_alpha = true,
    		sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("mighty_morphin:command_center_tube", {
		description = "Tube",
		tiles = {"command_center_tube_edge.png", "command_center_tube.png"},
		drawtype = "glasslike_framed",
    		inventory_image = minetest.inventorycube("command_center_tube_inv.png"),

    		paramtype = "light",
			light_source = 8,
    		sunlight_propagates = true,
    		is_ground_content = false,

    		groups = {cracky = 3, oddly_breakable_by_hand = 3},
			use_texture_alpha = true,
    		sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("mighty_morphin:command_center_wall_light", {
		description = "Command Center Wall Light",
		tiles = {"command_center_wall_light.png"},
    	inventory_image = minetest.inventorycube("command_center_wall_light.png"),
    	paramtype = "light",
		light_source = 14,
    	is_ground_content = false,
    	groups = {cracky = 3, oddly_breakable_by_hand = 3},
})

minetest.register_node("mighty_morphin:command_center_rail", {
	description = "Command Center Rail",
	tiles = {
		"command_center_rail.png",
		"command_center_rail.png",
		"command_center_rail.png",
		"command_center_rail.png",
		"command_center_rail.png",
		"command_center_rail.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_metal_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{0.4375, -0.5, 0.4375, 0.5, 0.5, 0.5},
			{-0.5, -0.5, 0.4375, -0.4375, 0.5, 0.5},
			{-0.5, 0.4375, 0.4375, 0.5, 0.5, 0.5},
			{-0.5, 0, 0.4375, 0.5, 0.0625, 0.5},
		}
	}
})

minetest.register_node("mighty_morphin:command_center_rail_corner", {
	description = "Command Center Rail Corner",
	tiles = {
		"command_center_rail.png",
		"command_center_rail.png",
		"command_center_rail.png",
		"command_center_rail.png",
		"command_center_rail.png",
		"command_center_rail.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_metal_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{0.4375, -0.5, 0.4375, 0.5, 0.5, 0.5},
			{-0.5, -0.5, 0.4375, -0.4375, 0.5, 0.5},
			{-0.5, 0.4375, 0.4375, 0.5, 0.5, 0.5},
			{-0.5, 0, 0.4375, 0.5, 0.0625, 0.5},
			{-0.5, -0.5, -0.5, -0.4375, 0.5, -0.4375},
			{-0.5, 0.4375, -0.5, -0.4375, 0.5, 0.5},
			{-0.5, 0, -0.5, -0.4375, 0.0625, 0.5},
		}
	}
})
