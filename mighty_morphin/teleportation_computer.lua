minetest.register_node("mighty_morphin:command_center_teleportation_computer", {
	description = "Teleportation Computer",
	tiles = {
		"command_center_teleportation_computer.png",
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
	}
})