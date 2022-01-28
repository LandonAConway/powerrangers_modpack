morphin_masters.master_staff = {}
morphin_masters.master_staff.data = {}

local set_staff_property = function(player, property, value)
	local name = player:get_player_name()
	local data = morphin_masters.master_staff.data
	
	data[name] = data[name] or {}
	data[name][property] = value
end

local get_staff_property = function(player, property)
	local name = player:get_player_name()
	local data = morphin_masters.master_staff.data
	
	return data[name][property]
end

morphinggrid.register_griditem("morphin_masters:master_staff", {
	type = "tool",
	description = "Master Staff",
	inventory_image = "morphin_masters_master_staff.png",
	prevents_respawn = true,
	tool_capabilities = {
		damage_groups = { fleshy = 700 }
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
					set_staff_property(player, "mode", text)
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
					set_staff_property(player, "drop", text)
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
					set_staff_property(player, "morph", text)
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
		
		if meta:get_string("mode") == "" then
			meta:set_string("mode", get_staff_property(player, "mode") or "attack")
		end
		
		if meta:get_string("drop") == "" then
			meta:set_string("drop", get_staff_property(player, "drop") or "")
		end
		
		if meta:get_string("morph") == "" then
			meta:set_string("morph", get_staff_property(player, "morph") or "")
		end
		
		local mode = meta:get_string("mode")
		
		if mode == "attack" then
			if pointed_thing.ref ~= nil then
				pointed_thing.ref:punch(player, 0, itemdef.tool_capabilities, nil)
			end
		elseif mode == "drop" then
			local dropitem = meta:get_string("drop")
			if minetest.registered_items[dropitem] then
				minetest.item_drop(ItemStack(dropitem), player, player:get_pos())
			end
		elseif mode == "morph" then
			if pointed_thing.ref ~= nil then
				local obj = pointed_thing.ref
				if obj:is_player() then
					local rangerstring = meta:get_string("morph")
					if morphinggrid.registered_rangers[rangerstring] then
						morphinggrid.morph(player, rangerstring)
					end
				end
			end
		end
	end
})

