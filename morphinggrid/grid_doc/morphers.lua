-- grid_doc = {
			-- inputs = {
				-- { input = {"mighty_morphin:tigerzord_powercoin"} },
				-- { input = {"mighty_morphin:dragonzord_powercoin"} },
				-- { input = {"mighty_morphin:mastodon_powercoin"} },
				-- { input = {"mighty_morphin:pterodactyl_powercoin"} },
				-- { input = {"mighty_morphin:triceratops_powercoin"} },
				-- { input = {"mighty_morphin:saber_toothed_tiger_powercoin"} },
				-- { input = {"mighty_morphin:tyrannosaurus_powercoin"} },
			-- }
		-- }

morphinggrid.grid_doc.register_inventory("morpher_slots", {
	size=5*3,
	allow_move = function() return 0 end,
	allow_take = function() return 0 end,
	allow_put = function() return 0 end
})

local function count_table(t)
	local i = 0
	for _ in pairs(t) do
		i = i + 1
	end
	return i
end

grid_doc = { morpher_slots = {} }

morphinggrid.grid_doc.register_type("morphers", {
	description = "Morphers",
	
	formspec = function(player, itemstring)
		local itemdef = minetest.registered_items[itemstring]
		local player_name = player:get_player_name()
		local current = morphinggrid.grid_doc.current[player_name]
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
		
		current.morpher_slots = current.morpher_slots or {}
		current.morpher_slots.input_max = current.morpher_slots.input_max or 1
		current.morpher_slots.input_current = current.morpher_slots.input_current or 1
		current.item = itemstring
		local morpher_slots = ""
		if itemdef.morpher_slots then
			--9.7
			if itemdef.morpher_slots.grid_doc and count_table(itemdef.morpher_slots.grid_doc.inputs or {}) > 0 then
				current.morpher_slots.input_max = count_table(itemdef.morpher_slots.grid_doc.inputs or {})
				
				local input_max = current.morpher_slots.input_max
				local input_current = current.morpher_slots.input_current
				local inputs = itemdef.morpher_slots.grid_doc.inputs
				local current_info = minetest.formspec_escape("["..input_current.."/"..input_max.."]")
				local info = "Morpher Slots "..current_info.."]:"
				if count_table(inputs[input_current].input or {}) < 1 then
					info = "Morpher Slots "..current_info.." ("..(inputs[input_current].info or "Remove any items to get a result.").."):"
				else
					if inputs[input_current].info then
						info = "Morpher Slots "..current_info.." ("..inputs[input_current].info.."):"
					else
						info = "Morpher Slots "..current_info..":"
					end
				end
				
				for _, v in pairs(inv:get_list("morpher_slots")) do
					inv:remove_item("morpher_slots", v)
				end
				
				for _, v in pairs(inputs[input_current].input or {}) do
					inv:add_item("morpher_slots", ItemStack(v))
				end
				
				morpher_slots = "label[9.7,3.6;"..info.."]"..
								"button[16.3,5.4;1,0.4;backbtn;<<]"..
								"button[17.5,5.4;1,0.4;nextbtn;>>]"..
								"list[detached:"..player_name.."_grid_doc;morpher_slots;9.7,3.8;5,3;0]"
			else
				morpher_slots = "label[9.7,3.6;This morpher utilizes morpher slots but there is no documentation.]"
				
				--refresh
				current.morpher_slots.input_max = 1
				current.morpher_slots.input_current = 1
			end
		else
			morpher_slots = "label[9.7,3.6;This morpher does not utilize morpher slots.]"
			
			--refresh
			current.morpher_slots.input_max = 1
			current.morpher_slots.input_current = 1
		end
		
		local f = "label[5.4,2.3;Name: "..(itemdef.description or itemstring).."]"..
		"label[5.4,2.8;Item String: "..itemstring.."]"..
		"style[description;border=false]"..
		"box[5.4,7.8;14.4,5;#0f0f0f]"..
		"textarea[5.4,7.8;14.4,5;description;;"..(grid_doc_def.description or "No description.").."]"..
		"list[detached:"..player_name.."_grid_doc;recipe;5.4,3.8;3,3;0]"..
		"list[detached:"..player_name.."_grid_doc;item;5.4,0.6;1,1;0]"..
		morpher_slots..
		"label[5.4,0.4;Item:]"..
		"label[5.4,3.6;"..recipe_status.."]"
		
		return f
	end,
	
	get_items = function()
		local t = {}
		for k, v in pairs(morphinggrid.registered_morphers) do
			table.insert(t, {desc=v.description or k, name=k, data={k}})
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
	end
})

minetest.register_on_player_receive_fields(function(player,formname,fields)
	if formname == "morphinggrid:grid_doc" then
		local player_name = player:get_player_name()
		local current = morphinggrid.grid_doc.current[player_name]
		if fields.backbtn then
			local input_max = current.morpher_slots.input_max
			local input_current = current.morpher_slots.input_current
			
			if input_current > 1 then
				current.morpher_slots.input_current = input_current - 1
			end
			
			morphinggrid.grid_doc.show_formspec(player:get_player_name(), current.selected_type, current.selected_item)
		elseif fields.nextbtn then
			local input_max = current.morpher_slots.input_max
			local input_current = current.morpher_slots.input_current
			
			if input_current < input_max then
				current.morpher_slots.input_current = input_current + 1
			end
			
			morphinggrid.grid_doc.show_formspec(player:get_player_name(), current.selected_type, current.selected_item)
		end
	end
end)