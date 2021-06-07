morphinggrid.grid_doc.register_inventory("team_weapons", {
	size=11*4,
	allow_move = function() return 0 end,
	allow_take = function() return 0 end,
	allow_put = function() return 0 end
})

morphinggrid.grid_doc.register_type("teams", {
	description = "Teams",
	
	formspec = function(player, rangertype)
		local itemdef = morphinggrid.registered_rangertypes[rangertype]
		local player_name = player:get_player_name()
		local inv = morphinggrid.grid_doc.get_inventory(player)
		local grid_doc_def = itemdef.grid_doc or {}
		
		morphinggrid.grid_doc.clear_lists(player) --do this anyway
		
		for i, v in pairs(inv:get_list("team_weapons")) do
			inv:remove_item("team_weapons", v)
		end
		
		for i, v in pairs(itemdef.weapons) do
			inv:add_item("team_weapons", ItemStack(v))
		end
		
		local f = "label[5.4,0.6;Name: "..(itemdef.description or rangertype).."]"..
		"label[5.4,1.1;Ranger String: "..rangertype.."]"..
		"style[description;border=false]"..
		"box[5.4,7.8;14.4,5;#0f0f0f]"..
		"textarea[5.4,7.8;14.4,5;description;;"..(grid_doc_def.description or "No description.").."]"..
		"list[detached:"..player_name.."_grid_doc;team_weapons;5.4,2.1;11,4;0]"..
		"label[5.4,1.9;Weapons:]"
		
		return f
	end,
	
	get_items = function()
		local t = {}
		for k, v in pairs(morphinggrid.registered_rangertypes) do
			table.insert(t, {desc=v.description or k, name=k, data={k}})
		end
		table.sort(t, function(a,b) return a.name < b.name end)
		return t
	end,
	
	filter = function(text, rangertype)
		local item = morphinggrid.registered_rangertypes[rangertype]
		if string.find(rangertype, text) or string.find(item.description or rangertype, text) then
			return true
		end
		return false
	end
})