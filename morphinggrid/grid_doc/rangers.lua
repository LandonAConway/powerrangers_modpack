-- label[5.4,2.3;Name:]
-- label[5.4,2.8;Item String:]
-- textarea[5.4,7.8;14.4,5;description;;No description.]
-- box[5.4,7.8;14.4,5;#0f0f0f]
-- list[detached:grid_doc;recipe;6.9,3.8;3,3;0]
-- list[detached:grid_doc;item;5.4,0.6;4,1;0]
-- label[5.4,0.4;Armor Items:]
-- label[5.4,3.6;Recipe:]

morphinggrid.grid_doc.register_inventory("armor_items", {
	size=4,
	allow_move = function() return 0 end,
	allow_take = function() return 0 end,
	allow_put = function() return 0 end
})

morphinggrid.grid_doc.register_inventory("ranger_weapons", {
	size=9*3,
	allow_move = function() return 0 end,
	allow_take = function() return 0 end,
	allow_put = function() return 0 end
})

morphinggrid.grid_doc.register_type("rangers", {
	description = "Rangers",
	
	formspec = function(player, rangername)
		local itemdef = morphinggrid.registered_rangers[rangername]
		local player_name = player:get_player_name()
		local inv = morphinggrid.grid_doc.get_inventory(player)
		local grid_doc_def = itemdef.grid_doc or {}
		local recipe_status = ""
		local rangername_parts = string.split(rangername, ":")
		
		morphinggrid.grid_doc.clear_lists(player) --do this anyway
		inv:set_stack("armor_items", 1, ItemStack(rangername_parts[1]..":helmet_"..rangername_parts[2]))--helmet chestplate leggings boots
		inv:set_stack("armor_items", 2, ItemStack(rangername_parts[1]..":chestplate_"..rangername_parts[2]))
		inv:set_stack("armor_items", 3, ItemStack(rangername_parts[1]..":leggings_"..rangername_parts[2]))
		inv:set_stack("armor_items", 4, ItemStack(rangername_parts[1]..":boots_"..rangername_parts[2]))
		
		for i, v in pairs(inv:get_list("ranger_weapons")) do
			inv:remove_item("ranger_weapons", v)
		end
		
		for i, v in pairs(itemdef.weapons) do
			inv:add_item("ranger_weapons", ItemStack(v))
		end
		
		local f = "label[5.4,2.3;Name: "..(itemdef.description or rangername).."]"..
		"label[5.4,2.8;Ranger String: "..rangername.."]"..
		"style[description;border=false]"..
		"box[5.4,7.8;14.4,5;#0f0f0f]"..
		"textarea[5.4,7.8;14.4,5;description;;"..(grid_doc_def.description or "No description.").."]"..
		"list[detached:"..player_name.."_grid_doc;ranger_weapons;6.9,3.8;9,3;0]"..
		"list[detached:"..player_name.."_grid_doc;armor_items;5.4,0.6;4,1;0]"..
		"label[5.4,0.4;Armor Items:]"..
		"label[5.4,3.6;Weapons:]"
		
		return f
	end,
	
	get_items = function()
		local t = {}
		for k, v in pairs(morphinggrid.registered_rangers) do
			local g = v.ranger_groups or {}
			local hidden = g.hidden or 0
			if hidden < 1 then
				table.insert(t, {desc=v.description or k, name=k, data={k}})
			end
		end
		table.sort(t, function(a,b) return a.name < b.name end)
		return t
	end,
	
	filter = function(text, rangerstring)
		local item = morphinggrid.registered_rangers[rangerstring]
		if string.find(rangerstring, text) or string.find(item.description or rangerstring, text) then
			return true
		end
		return false
	end
})