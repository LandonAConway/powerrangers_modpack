morphin_masters.master_staff = {}
morphin_masters.master_staff.data = {}

morphinggrid.register_griditem("morphin_masters:master_staff", {
	type = "tool",
	description = "Master Staff",
	inventory_image = "morphin_masters_master_staff.png",
	prevents_respawn = true,
	hp_multiplier = 0,
	punchback_multiplier = function(player, damage, _, _)
		local wielded_item = player:get_wielded_item()
		if wielded_item:get_name() == "morphin_masters:master_staff" then
			return damage*1.5
		end
		return 0
	end,
	tool_capabilities = {
		damage_groups = { fleshy = 800 }
	},
	ranger_weapon = {
		weapon_key = "master_staff",
		rangers = {
			"morphin_masters:green",
			"morphin_masters:white",
			"morphin_masters:black",
			"morphin_masters:pink",
			"morphin_masters:blue",
			"morphin_masters:yellow",
			"morphin_masters:red",
			"morphin_masters:silver",
			"morphin_masters:gold"
		}
	},
	griditem_commands = {
		mode = {
			description = "Sets the mode of the staff.",
			params = "<mode [attack, drop, morph]>",
			func = function(name, text, itemstack)
				if text == "attack" or text == "drop" or text == "morph" then
					local meta = itemstack:get_meta()
					meta:set_string("mode", text)
					return true, 'Mode set to "'..text..'".', itemstack
				end
				return false, '"'..text..'" is not a valid mode.'
			end
		},
		
		set_drop = {
			description = "Sets the Grid Item or Morpher that will be dropped.",
			params = "<itemstring>",
			func = function(name, text, itemstack)
				if morphinggrid.registered_griditems[text] or morphinggrid.registered_morphers[text] then
					local meta = itemstack:get_meta()
					meta:set_string("drop", text)
					return true, 'Drop set to "'..text..'".', itemstack
				end
				return false, '"'..text..'" is not a registered Grid Item or Morpher.'
			end
		},
		
		set_morph = {
			description = "Sets the ranger that the pointed player will morph into.",
			params = "<rangerstring>",
			func = function(name, text, itemstack)
				if morphinggrid.registered_rangers[text] then
					local meta = itemstack:get_meta()
					meta:set_string("morph", text)
					return true, 'Morph set to "'..text..'".', itemstack
				end
				return false, '"'..text..'" is not a registered Ranger.'
			end
		}
	},
	
	on_use = function(itemstack, player, pointed_thing)
		local meta = itemstack:get_meta()
		local itemdef = morphinggrid.registered_griditems[itemstack:get_name()]
		
		local mode = meta:get_string("mode")
		if mode ~= "attack" and mode ~= "drop" and mode ~= "morph" then
			mode = "attack"
		end
		
		if mode == "attack" then
			if pointed_thing.ref then
				pointed_thing.ref:punch(player, 0.1, itemdef.tool_capabilities, nil)
			end
		elseif mode == "drop" then
			local dropitem = meta:get_string("drop")
			if minetest.registered_items[dropitem] then
				minetest.item_drop(ItemStack(dropitem), player, player:get_pos())
			end
		elseif mode == "morph" then
			if pointed_thing.ref then
				local obj = pointed_thing.ref
				if obj:is_player() then
					local ranger = meta:get_string("morph")
					if morphinggrid.registered_rangers[ranger] then
						morphinggrid.morph(player, ranger)
					end
				end
			end
		end
	end
})

