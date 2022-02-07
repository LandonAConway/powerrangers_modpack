-- Mesecon Stuff
----------------

local rules = {
	{x = 1, y = 0, z = 0},
	{x =-1, y = 0, z = 0},
	{x = 0, y = 1, z = 0},
	{x = 0, y =-1, z = 0},
	{x = 0, y = 0, z = 1},
	{x = 0, y = 0, z =-1},
}

minetest.register_node("beast_morphers:white_light_block_off", {
    tiles = {"white_light_block.png"},
    description = "White Light Block",
    is_ground_content = false,
    groups = {cracky = 2, mesecon_effector_off = 1, mesecon = 2},
    description = desc,
    sounds = default.node_sound_glass_defaults(),
    mesecons = {effector = {
        action_on = function (pos, node)
			minetest.swap_node(pos, {name="beast_morphers:white_light_block_on"})
		end,
		rules = rules,
	}},
    on_blast = mesecon.on_blastnode,
})

minetest.register_node("beast_morphers:white_light_block_on", {
    tiles = {"white_light_block.png"},
    is_ground_content = false,
    groups = {cracky = 2, not_in_creative_inventory = 1, mesecon = 2},
    drop = "beast_morphers:white_light_block_off",
    light_source = minetest.LIGHT_MAX,
    sounds = default.node_sound_glass_defaults(),
    mesecons = {effector = {
		action_off = function (pos, node)
			minetest.swap_node(pos, {name="beast_morphers:white_light_block_off"})
		end,
		rules = rules,
	}},
    on_blast = mesecon.on_blastnode,
})