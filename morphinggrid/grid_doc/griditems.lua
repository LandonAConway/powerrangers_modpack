morphinggrid.grid_doc.register_type("griditems", {
	description = "Grid Items",
	
	formspec = function(player, itemstring)
		local itemdef = minetest.registered_items[itemstring]
		local player_name = player:get_player_name()
		local inv = morphinggrid.grid_doc.get_inventory(player)
		local grid_doc_def = itemdef.grid_doc or {}
		local recipe_status = ""
		
		morphinggrid.grid_doc.clear_lists(player)
		inv:set_stack("item", 1, itemstring)
		
		local craft = minetest.get_craft_recipe(itemstring) --input.method input.items
		if craft.items then
			if craft.method == "normal" then
				inv:set_list("recipe", craft.items)
			end
			recipe_status = "Recipe:"
		else
			recipe_status = "(No Recipe)"
		end
		
		local f = "label[5.4,2.3;Name: "..(itemdef.description or itemstring).."]"..
		"label[5.4,2.8;Item String: "..itemstring.."]"..
		"style[description;border=false]"..
		"box[5.4,7.8;14.4,5;#0f0f0f]"..
		"textarea[5.4,7.8;14.4,5;description;;"..(grid_doc_def.description or "No description.").."]"..
		"list[detached:"..player_name.."_grid_doc;recipe;5.4,3.8;3,3;0]"..
		"list[detached:"..player_name.."_grid_doc;item;5.4,0.6;1,1;0]"..
		"label[5.4,0.4;Item:]"..
		"label[5.4,3.6;"..recipe_status.."]"
		
		return f
	end,
	
	get_items = function()
		local t = {}
		for k, v in pairs(morphinggrid.registered_griditems) do
			local grid_doc = v.grid_doc or {}
			if not grid_doc.hidden then
				table.insert(t, {desc=v.description or k, name=k, data={k}})
			end
		end
		table.sort(t, function(a,b) return a.name < b.name end)
		return t
	end,
	
	filter = function(text, itemstring)
		local item = minetest.registered_items[itemstring]
		if string.find(itemstring, text) or string.find(item.description or itemstring, text) then
			return true
		end
		return false
	end,
	
	get_details = function(itemstring)
		local def = morphinggrid.registered_griditems[itemstring]
		local grid_doc = def.grid_doc or {}
		local details = {}
		
		-- prevents respawning
		local prevents_respawn = "No"
		if def.prevents_respawn then
			prevents_respawn = "Yes"
		end
		
		table.insert(details, { title = "Prevents Respawning     ", value = prevents_respawn,
				desc = grid_doc.prevents_respawn_desc or 
					"Prevents a player from respawning if placed in the Morphers Inventory." })
		
		-- custom details
		local custom_details = grid_doc.custom_details or {}
		for _, v in pairs(custom_details) do
			table.insert(details, v)
		end
		
		-- return
		return details
	end
})