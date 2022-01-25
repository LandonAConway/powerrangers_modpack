function mod_loaded(str)
	if minetest.get_modpath(str) ~= nil then
		return true
	end
	return false
end

minetest.register_node("mighty_morphin:zordon_tube", {
		description = "Zordon Tube",
		tiles = {"glass_no_edge.png", "zordon_tube.png"},
		drawtype = "glasslike_framed",
    		inventory_image = minetest.inventorycube("zordon_tube_inv.png"),

    		paramtype = "light",
			light_source = 10,
    		sunlight_propagates = true,
    		is_ground_content = false,

    		groups = {cracky = 3, oddly_breakable_by_hand = 3},
			use_texture_alpha = true,
    		sounds = default.node_sound_glass_defaults(),
			
			grid_doc = {
				other_item = true,
				description = "Zordon Tube is a decorative node which can be used to build a command center."
			}
})

minetest.register_node("mighty_morphin:command_center_tube", {
		description = "Tube",
		tiles = {"command_center_tube_edge.png", "command_center_tube.png"},
		drawtype = "glasslike_framed",
    		inventory_image = minetest.inventorycube("command_center_tube_inv.png"),

    		paramtype = "light",
			light_source = 7,
    		sunlight_propagates = true,
    		is_ground_content = false,

    		groups = {cracky = 3, oddly_breakable_by_hand = 3},
			use_texture_alpha = true,
    		sounds = default.node_sound_glass_defaults(),
			grid_doc = {
				other_item = true,
				description = "Tube (Aka 'Command Center Tube') is a decorative node which can be used to build a command center."
			}
})


if mod_loaded("mesecons") then

	minetest.register_node("mighty_morphin:powercoin_detector_off", {
			description = "Power Coin Detector",
			tiles = {"^[colorize:#ff0000"},
			paramtype = "light",
			is_ground_content = false,
			groups = {cracky = 3, stone=2, oddly_breakable_by_hand = 3},
			grid_doc = {
				other_item = true,
				description = "Power Coin Detector is a Mesecons receptor node that turns on when it detects a player with a power coin nearby."
			},
			
			mesecons = {
				receptor = {
					state = mesecon.state.off,
					rules = mesecon.rules
				}
			}
	})

	minetest.register_node("mighty_morphin:powercoin_detector_on", {
			description = "Power Coin Detector",
			tiles = {"^[colorize:#00ff00"},
			paramtype = "light",
			light_source = 14,
			is_ground_content = false,
			drop = {
				items = { { items = {'mighty_morphin:powercoin_detector_off'} } }
			},
			groups = {cracky = 3, stone=2, oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
			
			mesecons = {
				receptor = {
					state = mesecon.state.on,
					rules = mesecon.rules
				}
			}
	})
	
else
	
	minetest.register_node("mighty_morphin:powercoin_detector_off", {
			description = "Power Coin Detector",
			tiles = {"^[colorize:#ff0000"},
			paramtype = "light",
			is_ground_content = false,
			groups = {cracky = 3, stone=2, oddly_breakable_by_hand = 3},
			grid_doc = {
				other_item = true,
				description = "Power Coin Detector is a node that turns on when it detects a player with a power coin nearby. Install Mesecons for best experience."
			},
	})

	minetest.register_node("mighty_morphin:powercoin_detector_on", {
			description = "Power Coin Detector",
			tiles = {"^[colorize:#00ff00"},
			paramtype = "light",
			light_source = 14,
			is_ground_content = false,
			drop = {
				items = { { items = {'mighty_morphin:powercoin_detector_off'} } }
			},
			groups = {cracky = 3, stone=2, oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
	})
	
end

minetest.register_node("mighty_morphin:command_center_wall_light", {
		description = "Command Center Wall Light",
		tiles = {"command_center_wall_light.png"},
    	inventory_image = minetest.inventorycube("command_center_wall_light.png"),
    	paramtype = "light",
		light_source = 10,
    	is_ground_content = false,
    	groups = {cracky = 3, oddly_breakable_by_hand = 3},
		grid_doc = {
			other_item = true,
			description = "Command Center Wall Light is a decorative node used to lighten things up."
		}
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
	},
	grid_doc = {
		other_item = true,
		description = "Command Center Rail is a decorative node which can be used to build a command center."
	}
})

minetest.register_node("mighty_morphin:command_center_counter", {
	description = "Command Center Counter",
	tiles = {
		"command_center_counter.png",
		"command_center_counter.png",
		"command_center_counter.png",
		"command_center_counter.png",
		"command_center_counter.png",
		"command_center_counter.png"
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
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
		}
	},
	grid_doc = {
		other_item = true,
		description = "Command Center Counter is a decorative node which can be used to build a command center."
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
	},
	grid_doc = {
		other_item = true,
		description = "Command Center Rail Corner is a decorative node which can be used to build a command center."
	}
})

minetest.register_node("mighty_morphin:metal_grid_floor_1_4", {
	description = "Metal Grid Floor 1/4",
	tiles = {
		"metal_grid_floor_top.png",
		"metal_grid_floor_top.png",
		"metal_grid_floor_side.png",
		"metal_grid_floor_side.png",
		"metal_grid_floor_side.png",
		"metal_grid_floor_side.png"
	},
	drawtype = "nodebox",
	use_texture_alpha = true,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_metal_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.25, -0.5, 0.5, 0.5, 0.5},
		}
	},
	grid_doc = {
		other_item = true,
		description = "Metal Grid Floor pieces are used as part of the flooring of the command center."
	}
})

minetest.register_node("mighty_morphin:metal_grid_floor_2_4", {
	description = "Metal Grid Floor 2/4",
	tiles = {
		"metal_grid_floor_top.png",
		"metal_grid_floor_top.png",
		"metal_grid_floor_side.png",
		"metal_grid_floor_side.png",
		"metal_grid_floor_side.png",
		"metal_grid_floor_side.png"
	},
	drawtype = "nodebox",
	use_texture_alpha = true,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_metal_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0, -0.5, 0.5, 0.25, 0.5},
		}
	},
	grid_doc = {
		other_item = true,
		description = "Metal Grid Floor pieces are used as part of the flooring of the command center."
	}
})

minetest.register_node("mighty_morphin:metal_grid_floor_3_4", {
	description = "Metal Grid Floor 3/4",
	tiles = {
		"metal_grid_floor_top.png",
		"metal_grid_floor_top.png",
		"metal_grid_floor_side.png",
		"metal_grid_floor_side.png",
		"metal_grid_floor_side.png",
		"metal_grid_floor_side.png"
	},
	drawtype = "nodebox",
	use_texture_alpha = true,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_metal_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.25, -0.5, 0.5, 0, 0.5},
		}
	},
	grid_doc = {
		other_item = true,
		description = "Metal Grid Floor pieces are used as part of the flooring of the command center."
	}
})

minetest.register_node("mighty_morphin:metal_grid_floor_4_4", {
	description = "Metal Grid Floor 4/4",
	tiles = {
		"metal_grid_floor_top.png",
		"metal_grid_floor_top.png",
		"metal_grid_floor_side.png",
		"metal_grid_floor_side.png",
		"metal_grid_floor_side.png",
		"metal_grid_floor_side.png"
	},
	drawtype = "nodebox",
	use_texture_alpha = true,
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_metal_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		}
	},
	grid_doc = {
		other_item = true,
		description = "Metal Grid Floor pieces are used as part of the flooring of the command center."
	}
})

