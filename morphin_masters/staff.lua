local rangers = {
	green = { desc = "Green" },
	white = { desc = "White" },
	black = { desc = "Black" },
	pink = { desc = "Pink" },
	blue = { desc = "Blue" },
	yellow = { desc = "Yellow" },
	red = { desc = "Red" },
	silver = { desc = "Silver" },
	gold = { desc = "Gold" },
}

for k, v in pairs(rangers) do
	morphinggrid.register_morpher("morphin_masters:staff_"..k, {
		type = "tool",
		description = v.desc.." Morphin Master Staff",
		inventory_image = "morphin_masters_staff_"..k..".png",
		register_griditem = true,
		prevents_respawn = true,
		hp_multiplier = 0,
		punchback_multiplier = 1,
		ranger = "morphin_masters:"..k,
		tool_capabilities = {
			full_punch_interval = 0.1,
			max_drop_level=1,
			groupcaps={
				snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
				cracky={times={[50]=0.10}, uses=1, maxlevel=50},
			},
			damage_groups = {fleshy=250},
		},
		griditem_commands = {
			mode = {
				description = "Sets the mode of the staff.",
				params = "<mode [attack, morph]>",
				func = function(name, text, itemstack)
					if text == "attack" or text == "drop" or text == "morph" then
						local meta = itemstack:get_meta()
						meta:set_string("mode", text)
						return true, 'Mode set to "'..text..'".', itemstack
					end
					return false, '"'..text..'" is not a valid mode.'
				end
			},
			
			set_morph = {
				description = "Sets the ranger that the pointed player will morph into. Must be same color as staff.",
				params = "<rangerstring>",
				func = function(name, text, itemstack)
					local ranger = morphinggrid.registered_rangers[text]
					if ranger then
						if ranger.color == k then
							local meta = itemstack:get_meta()
							meta:set_string("morph", text)
							return true, 'Morph set to "'..text..'".', itemstack
						end
						return false, '"'..text..'" does not belong to the same color group as "morphin_masters:'..k..'".'
					end
					return false, '"'..text..'" is not a registered ranger.'
				end
			},

			toggle_enerform = {
				description = "Toggles Enerform.",
				func = function(name)
					local player = minetest.get_player_by_name(name)
					morphin_masters.enerform_set_color(player, k)
					morphin_masters.enerform_toggle(player)
				end
			}
		},
		morpher_commands = {
			toggle_enerform = {
				description = "Toggles Enerform.",
				func = function(name)
					local player = minetest.get_player_by_name(name)
					morphin_masters.enerform_set_color(player, k)
					morphin_masters.enerform_toggle(player)
				end
			}
		},
		morpher_slots = {
			amount = 1,
			load_input = function(itemstack)
				return true, {ItemStack("morphin_masters:master_crystal_"..k)}
			end,
			output = function(itemstack, slots)
				if slots[1]:get_name() == "" then
					return true, ItemStack("morphin_masters:staff")
				end
				return false, itemstack
			end,
			allow_put = function()
				return 0
			end,
			grid_doc = {
			inputs = {
					{ input = {} }
				}
			}
		},
		
		morph_func_override = function(player, itemstack)
			if morphinggrid.get_morph_status(player) ~= "morphin_masters:"..k then
				morphinggrid.morph(player, "morphin_masters:"..k, {morpher=itemstack:get_name(), itemstack=itemstack})
			end
		end,
		
		on_use = function(itemstack, player, pointed_thing)
			local meta = itemstack:get_meta()
			if meta:get_string("mode") == "" or meta:get_string("mode") == "attack" then
				local ctrl = player:get_player_control()
				if ctrl.RMB then
					for _, v in pairs(minetest.get_objects_inside_radius(player:get_pos(), 15)) do
						local capabilities = {
							full_punch_interval = 0.1,
							max_drop_level=1,
							damage_groups = {fleshy=75},
						}
						if v:is_player() and v:get_player_name() == player:get_player_name() then
							--do nothing
						else
							v:punch(player, 0.1, capabilities)
						end
					end
				else
					if pointed_thing.ref ~= nil then
						local tool_capabilities = morphinggrid.registered_morphers[itemstack:get_name()].tool_capabilities
						pointed_thing.ref:punch(player, 0.1, tool_capabilities, nil)
					end
				end
			elseif meta:get_string("mode") == "morph" then
				local ranger = meta:get_string("morph")
				if ranger == "" then ranger = "morphin_masters:"..k end
				if morphinggrid.registered_rangers[ranger] then
					local obj = pointed_thing.ref
					if obj then
						if obj:is_player() then
							morphinggrid.morph(obj, ranger)
						end
					end
				end
			end
		end
	})
	
	morphinggrid.register_griditem("morphin_masters:master_crystal_"..k, {
		description = "Master Crystal "..v.desc,
		inventory_image = "morphin_masters_master_crystal_"..k..".png",
		prevents_respawn = true
	})
end

morphinggrid.register_morpher("morphin_masters:staff", {
	type = "tool",
	description = "Morphin Master Staff",
	inventory_image = "morphin_masters_staff.png",
	is_connected = false,
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level=1,
		damage_groups = {fleshy=8},
	},
	grid_doc = {
		description = [[An empty Morphin Master Staff. You can input any Master Crystal into it's slots to get a Morphin Master Staff.
				Use chat command '/morpher slots' when wielding it).]]
	},
	
	morpher_slots = {
		amount = 1,
		load_input = function(morpher)
			return true, {}
		end,
		
		output = function(morpher, slots)
			if slots[1]:get_name() == "morphin_masters:master_crystal_green" then
				return true, ItemStack("morphin_masters:staff_green")
			elseif slots[1]:get_name() == "morphin_masters:master_crystal_white" then
				return true, ItemStack("morphin_masters:staff_white")
			elseif slots[1]:get_name() == "morphin_masters:master_crystal_black" then
				return true, ItemStack("morphin_masters:staff_black")
			elseif slots[1]:get_name() == "morphin_masters:master_crystal_pink" then
				return true, ItemStack("morphin_masters:staff_pink")
			elseif slots[1]:get_name() == "morphin_masters:master_crystal_blue" then
				return true, ItemStack("morphin_masters:staff_blue")
			elseif slots[1]:get_name() == "morphin_masters:master_crystal_yellow" then
				return true, ItemStack("morphin_masters:staff_yellow")
			elseif slots[1]:get_name() == "morphin_masters:master_crystal_red" then
				return true, ItemStack("morphin_masters:staff_red")
			elseif slots[1]:get_name() == "morphin_masters:master_crystal_silver" then
				return true, ItemStack("morphin_masters:staff_silver")
			elseif slots[1]:get_name() == "morphin_masters:master_crystal_gold" then
				return true, ItemStack("morphin_masters:staff_gold")
			end
			return false, morpher
		end,
		
		allow_put = function(morpher, itemstack)
			if itemstack:get_name() == "morphin_masters:master_crystal_green" or
				itemstack:get_name() == "morphin_masters:master_crystal_white" or
				itemstack:get_name() == "morphin_masters:master_crystal_black" or
				itemstack:get_name() == "morphin_masters:master_crystal_pink" or
				itemstack:get_name() == "morphin_masters:master_crystal_blue" or
				itemstack:get_name() == "morphin_masters:master_crystal_yellow" or
				itemstack:get_name() == "morphin_masters:master_crystal_red" or
				itemstack:get_name() == "morphin_masters:master_crystal_silver" or
				itemstack:get_name() == "morphin_masters:master_crystal_gold"
					then
				return 1
			end
			return 0
		end,
		
		grid_doc = {
			inputs = {
				{ input = {"morphin_masters:master_crystal_green"} },
				{ input = {"morphin_masters:master_crystal_white"} },
				{ input = {"morphin_masters:master_crystal_black"} },
				{ input = {"morphin_masters:master_crystal_pink"} },
				{ input = {"morphin_masters:master_crystal_blue"} },
				{ input = {"morphin_masters:master_crystal_yellow"} },
				{ input = {"morphin_masters:master_crystal_red"} },
				{ input = {"morphin_masters:master_crystal_silver"} },
				{ input = {"morphin_masters:master_crystal_gold"} },
			}
		}
	}
})