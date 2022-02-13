morphinggrid.grid_doc.types = {}

function morphinggrid.grid_doc.register_type(name, def)
	def.description = def.description or "Untitled"
	def.formspec = def.formspec or function() return "" end
	def.get_items = def.get_items or function() return {} end
	morphinggrid.grid_doc.types[name] = def
end

--functionality
local get_types = function()
	local t = {}
	for k, v in pairs(morphinggrid.grid_doc.types) do
		table.insert(t, {name=k,desc=v.description})
	end
	return t
end

local get_type_descs = function()
	local t = {}
	for i, v in pairs(get_types()) do
		table.insert(t, v.desc)
	end
	return t
end

local get_items = function(selected_type, filter)
	if filter ~= "" and filter ~= nil then
		local t = {}
		for i, v in pairs(morphinggrid.grid_doc.types[get_types()[selected_type].name].get_items()) do
			local func = morphinggrid.grid_doc.types[get_types()[selected_type].name].filter or function() return true end
			if func(filter, unpack(v.data)) then
				table.insert(t, v)
			end
		end
		return t
	end
	return morphinggrid.grid_doc.types[get_types()[selected_type].name].get_items()
end

local get_item_descs = function(selected_type, filter)
	local t = {}
	for i, v in pairs(get_items(selected_type, filter)) do
		table.insert(t, v.desc)
	end
	return t
end

local function get_items_details(selected_type, filter)
	local t = {}
	local func = morphinggrid.grid_doc.types[get_types()[selected_type].name].get_details
	if func then
		local items = get_items(selected_type, filter)
		for i, v in ipairs(items) do
			table.insert(t, func(v.name))
		end
	else
		return nil
	end
	return t
end

function morphinggrid.grid_doc.formspec(player, selected_type, selected_item)
	selected_type = selected_type or 1
	local current = morphinggrid.grid_doc.current[player] or {selected_type=1,selected_item=1,filter=""}
	current.filter = current.filter or ""
	current.items_details = get_items_details(selected_type, current.filter)
	local inv = morphinggrid.grid_doc.get_inventory(minetest.get_player_by_name(player))
	local data = (get_items(selected_type, current.filter)[selected_item] or {}).data
	local typedef = morphinggrid.grid_doc.types[get_types()[selected_type].name]
	table.insert(data or {}, 1, minetest.get_player_by_name(player))
	
	local details_btn = ""
	if current.items_details then
		details_btn = "button[12.3,13;4,0.8;details;Details]"
	end
	
	local part2 = ""
	if data then
		part2 = morphinggrid.grid_doc.types[get_types()[selected_type].name].formspec(unpack(data))
	end
	
	local formspec = "formspec_version[4]"..
	"size[20,14]"..
	"textlist[0.2,0.2;5,3;item_types;"..table.concat(get_type_descs(),",")..";"..selected_type..";false]"..
	"textlist[0.2,4.4;5,9.4;items;"..table.concat(get_item_descs(selected_type, current.filter),",")..";"..selected_item..";false]"..
	"textarea[0.2,3.4;3.3,0.8;search;;"..current.filter.."]"..
	"button[3.7,3.4;1.5,0.8;searchbtn;Search]"..
	"button_exit[16.8,13;3,0.8;exit;Exit]"..
	details_btn..
	
	part2
	
	
	return formspec
end

function morphinggrid.grid_doc.show_formspec(player, selected_type, selected_item)
	minetest.show_formspec(player, "morphinggrid:grid_doc", morphinggrid.grid_doc.formspec(player, selected_type, selected_item))
end

local function show_formspec(player, selected_type, selected_item)
	morphinggrid.grid_doc.show_formspec(player, selected_type, selected_item)
end

function morphinggrid.grid_doc.get_inventory(player)
	local inv = minetest.get_inventory({type="detached", name=player:get_player_name(player).."_grid_doc"})
	return inv
end

function morphinggrid.grid_doc.clear_lists(player)
	local inv = morphinggrid.grid_doc.get_inventory(player)
	for i, v in ipairs(inv:get_list("item")) do
		inv:remove_item("item", v)
	end
	
	for i, v in ipairs(inv:get_list("recipe")) do
		inv:remove_item("recipe", v)
	end
end

morphinggrid.grid_doc.current = {}

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "morphinggrid:grid_doc" then
		morphinggrid.grid_doc.current[player:get_player_name()] = morphinggrid.grid_doc.current[player:get_player_name()] or {}
		local current = morphinggrid.grid_doc.current[player:get_player_name()]
		current.selected_type = current.selected_type or 1
		current.selected_item = current.selected_item or 1
		current.filter = current.filter or fields.search
		
		if fields.item_types then
			local e = minetest.explode_textlist_event(fields.item_types)
			current.selected_type = e.index
			if e.type == "CHG" then
				show_formspec(player:get_player_name(), e.index, 1)
			end
		elseif fields.items then
			local e = minetest.explode_textlist_event(fields.items)
			current.selected_item = e.index
			if e.type == "CHG" then
				show_formspec(player:get_player_name(), current.selected_type, e.index)
			end
		elseif fields.searchbtn then
			current.filter = fields.search
			show_formspec(player:get_player_name(), current.selected_type, current.selected_item)
		elseif fields.details then
			local go_back = function()
				show_formspec(player:get_player_name(), current.selected_type, current.selected_item)
			end
			
			morphinggrid.grid_doc.show_list_dialog_formspec(player, "Details", current.items_details[current.selected_item],
				nil, go_back)
		end
	end
end)

morphinggrid.grid_doc.registered_inventories = {}
function morphinggrid.grid_doc.register_inventory(name, def)
	def.name = name
	def.size = def.size or 1
	morphinggrid.grid_doc.registered_inventories[name] = def
end

morphinggrid.grid_doc.register_inventory("item", {
	size = 1*1,
	allow_move = function() return 0 end,
	allow_put = function() return 0 end,
	allow_take = function() return 0 end
})

morphinggrid.grid_doc.register_inventory("recipe", {
	size = 3*3,
	allow_move = function() return 0 end,
	allow_put = function() return 0 end,
	allow_take = function() return 0 end
})

minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	
	minetest.create_detached_inventory(player_name.."_grid_doc", {
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			local f = morphinggrid.grid_doc.registered_inventories[from_list].allow_move or function() return count end
			return f(inv, from_list, from_index, to_list, to_index, count, player)
		end,
		
		allow_put = function(inv, listname, index, stack, player)
			local f = morphinggrid.grid_doc.registered_inventories[listname].allow_put or function() return stack:get_count() end
			return f(inv, listname, index, stack, player)
		end,
		
		allow_take = function(inv, listname, index, stack, player)
			local f = morphinggrid.grid_doc.registered_inventories[listname].allow_take or function() return stack:get_count() end
			return f(inv, listname, index, stack, player)
		end,
		
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			local f = morphinggrid.grid_doc.registered_inventories[from_list].on_move or function() return count end
			return f(inv, from_list, from_index, to_list, to_index, count, player)
		end,
		
		on_put = function(inv, listname, index, stack, player)
			local f = morphinggrid.grid_doc.registered_inventories[listname].on_put or function() return stack:get_count() end
			return f(inv, listname, index, stack, player)
		end,
		
		on_take = function(inv, listname, index, stack, player)
			local f = morphinggrid.grid_doc.registered_inventories[listname].on_take or function() return stack:get_count() end
			return f(inv, listname, index, stack, player)
		end
	})
	
	local inv = minetest.get_inventory({type="detached", name=player_name.."_grid_doc"})
	
	for k, v in pairs(morphinggrid.grid_doc.registered_inventories) do
		inv:set_size(k, v.size)
	end
end)

--list dialog
local function build_textlist(items)
	local t = {}
	for i, v in pairs(items) do
		table.insert(t, "1,"..
				(v.title or "") .. "," ..
				(v.value or "nil") )
	end
	return table.concat(t, ",")
end

morphinggrid.grid_doc.current_list_dialog = {}
function morphinggrid.grid_doc.list_dialog_formspec(player, listdesc, items, index, go_back)
	items = items or {
		{ title = "", desc = "" }
	}
	index = index or 1
	
	if items[1] == nil then
		items = {{title="",desc=""}}
	end
	
	--data
	morphinggrid.grid_doc.current_list_dialog[player:get_player_name()] = { 
		listdesc = listdesc,
		items = items,
		go_back = go_back
	}
	
	local titles = {}
	for i, v in ipairs(items) do
		table.insert(titles, v.title)
	end
	
	local size = "10.5,11"
	local go_back_btn = ""
	
	if type(go_back) == "function" then
		size = "10.5,14"
		go_back_btn = "button[3.75,12.8;3,0.8;go_back;Go Back]"
	end
	
	local formspec = "formspec_version[4]"..
	"size["..size.."]"..
	go_back_btn..
	"label[0.2,0.4;"..listdesc..":]"..
	"label[0.2,8.5;Description:]"..
	"tablecolumns[tree;text;text]"..
	"table[0.2,0.6;10.1,7.5;list;"..build_textlist(items).."]"..
	"textarea[0.2,8.8;10.1,2;description;;"..items[index].desc or "".."]"
	
	return formspec
end

function morphinggrid.grid_doc.show_list_dialog_formspec(player, listdesc, items, index, go_back)
	minetest.show_formspec(player:get_player_name(), "morphinggrid:grid_doc_list_dialog",
		morphinggrid.grid_doc.list_dialog_formspec(player, listdesc, items, index, go_back))
end

local function show_list_dialog_formspec(player, listdesc, items, index, go_back)
	morphinggrid.grid_doc.show_list_dialog_formspec(player, listdesc, items, index, go_back)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "morphinggrid:grid_doc_list_dialog" then
		local current = morphinggrid.grid_doc.current_list_dialog[player:get_player_name()]
		if fields.list then
			local e = minetest.explode_table_event(fields.list)
			if(e.type == "CHG") then
				show_list_dialog_formspec(player, current.listdesc, current.items, e.row, current.go_back)
			end
		elseif fields.go_back then
			if type(current.go_back) == "function" then
				current.go_back(player)
			end
		end
	end
end)