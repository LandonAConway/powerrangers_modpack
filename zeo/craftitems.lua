morphinggrid.register_morpher("zeo:gold_staff", {
  type = "tool",
  register_griditem = true,
  description = "Gold Zeo Staff",
  inventory_image = "zeo_gold_staff.png",
  prevents_respawn = true,
  rangers = { "zeo:gold" },
  ranger_weapon = {
    weapon_key = "zeo_gold_staff",
    rangers = { "zeo:gold" },
  },
  tool_capabilities = {
    full_punch_interval = 0.1,
    max_drop_level=1,
    groupcaps={
      snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
      cracky={times={[50]=0.10}, uses=1, maxlevel=50},
    },
    damage_groups = {fleshy=100},
  },
  sound = {breaks = "default_tool_breaks"},
  groups = {sword = 1, morpher=1},
  
  morph_func_override = function(user, itemstack)
      local morphstate = morphinggrid.get_morph_status(user)
      if morphstate ~= "zeo:gold" then
        local ranger = morphinggrid.get_ranger("zeo:gold")
        zeo.morph(user, ranger, itemstack)
      end
  end,
	grid_doc = {
		description = "The Gold Zeo Staff not only provides the Gold Zeo Ranger powers, but is also the ranger's main weapon when morphed."
	}
})

morphinggrid.register_morpher("zeo:right_zeonizer", {
	description = "Right Zeonizer",
	inventory_image = "zeo_zeonizer_right.png",
	groups = {not_in_creative_inventory=1},
	has_connection = false,
	
	morpher_slots = {
		amount = 1,
		load_input = function(morpher)
			return true, {}
		end,
		output = function(morpher, slots)
			if slots[1]:get_name() == "zeo:zeo_crystal_1" then
				return true, ItemStack("zeo:right_zeonizer_pink")
			elseif slots[1]:get_name() == "zeo:zeo_crystal_2" then
				return true, ItemStack("zeo:right_zeonizer_yellow")
			elseif slots[1]:get_name() == "zeo:zeo_crystal_3" then
				return true, ItemStack("zeo:right_zeonizer_blue")
			elseif slots[1]:get_name() == "zeo:zeo_crystal_4" then
				return true, ItemStack("zeo:right_zeonizer_green")
			elseif slots[1]:get_name() == "zeo:zeo_crystal_5" then
				return true, ItemStack("zeo:right_zeonizer_red")
			end
			
			return false, morpher
		end,
		allow_put = function(morpher, itemstack)
			if itemstack:get_name() == "zeo:zeo_crystal_1" or
			itemstack:get_name() == "zeo:zeo_crystal_2" or
			itemstack:get_name() == "zeo:zeo_crystal_3" or
			itemstack:get_name() == "zeo:zeo_crystal_4" or
			itemstack:get_name() == "zeo:zeo_crystal_5" then
				return 1
			end
			return 0
		end,
		grid_doc = {
			inputs = {
				{ input = {"zeo:zeo_crystal_1"} },
				{ input = {"zeo:zeo_crystal_2"} },
				{ input = {"zeo:zeo_crystal_3"} },
				{ input = {"zeo:zeo_crystal_4"} },
				{ input = {"zeo:zeo_crystal_5"} },
			}
		},
	},
	
	grid_doc = {
		description = "Holds a zeo crystal using morpher slots. To use morpher slots, type the chat command '/morpher slots' when wielding this item."
	}
})

morphinggrid.register_morpher("zeo:left_zeonizer", {
  description = "Left Zeonizer",
  inventory_image = "zeo_zeonizer_left.png",
  has_connection = false,
  groups = {not_in_creative_inventory=1},
  grid_doc = {
	description = "Allows a player to morph when using a Right Zeonizer to morph if placed in a player's inventory."
  }
})