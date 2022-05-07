--A list of callbacks that are used by the grid functions.
local callbacks = {
	on_construct = true,
	on_destruct = true,
	after_destruct = true,
	on_place = true, --tool, craftitem, node
	on_drop = true, --tool, craftitem, node
	on_use = true, --tool, craftitem, node
	after_use = true, --tool, craftitem, node
	on_punch = true,
	on_dig = true,
	on_timer = true,
	on_recieve_fields = true,
	allow_metadata_inventory_move = true,
	allow_metadata_inventory_put = true,
	allow_metadata_inventory_take = true,
	on_metadata_inventory_move = true,
	on_metadata_inventory_put = true,
	on_metadata_inventory_take = true,
	after_place_node = true,
	can_dig = true,
	after_dig_node = true,
	on_rightclick = true,
	on_secondary_use = true, --tool, craftitem, node
	on_flood = true,
	preserve_metadata = true,
	on_blast = true
}

local callback_data = {
	on_construct = {
		default_func = function(pos) end,
		args = {
			{"pos", "<table>", ""}
		}
	},
	
	on_destruct = {
		default_func = function(pos) end,
		args = {
			{"pos", "<table>", ""}
		}
	},
	
	after_destruct = {
		default_func = function(pos, oldnode) end,
		args = {
			{"pos", "<table>", ""}, {"oldnode", "<table>", ""}
		}
	},
	
	on_place = {
		default_func = function(itemstack, placer, pointed_thing) minetest.item_place(itemstack, placer, pointed_thing) end, --check
		args = {
			{"itemstack", "<ItemStack>", ""}, {"placer", "<Player>", ""}, {"pointed_thing", "<table>", ""}
		}
	},
	
	on_drop = {
		default_func = function(itemstack, dropper, pos) minetest.item_drop(itemstack, dropper, pos) return itemstack end,
		args = {
			{"itemstack", "<ItemStack>", ""}, {"dropper", "<Player>", ""}, {"pos", "<table>", ""}
		}
	},
	
	on_use = {
		default_func = function(itemstack, user, pointed_thing)
			if pointed_thing.type == "object" then
				local en = pointed_thing.ref:get_luaentity()
				if en and en.itemstring ~= nil and en.itemstring ~= "" then
					if user:is_player() then
						minetest.chat_send_all(en.itemstring)
						
						local itemstring = string.split(en.itemstring, " ")[1]
						
						user:get_inventory():add_item("main", ItemStack(en.itemstring))
						en.object:remove()
						
						if itemstack:get_name() == itemstring then
							return ItemStack(itemstring.." "..current_count)
						end
					end
				end
			end
		end,
		args = {
			{"itemstack", "<ItemStack>", ""}, {"user", "<Player>", ""}, {"pointed_thing", "<table>", ""}
		}
	},
	
	after_use = {
		default_func = function(itemstack, user, node, digparams) end,
		args = {
			{"itemstack", "<ItemStack>", ""}, {"user", "<Player>", ""}, {"node", "<table>", ""}, "digparams"
		}
	},
	
	on_punch = {
		default_func = function(pos, node, puncher, pointed_thing) minetest.node_punch(pos, node, puncher, pointed_thing) end,
		args = {
			{"pos", "<table>", ""}, {"node", "<table>", ""}, {"puncher", "<Player>", ""}, {"pointed_thing", "<table>", ""}
		}
	},
	
	on_dig = {
		default_func = function(pos, node, digger) minetest.node_dig(pos, node, digger) end,
		args = {
			{"pos", "<table>", ""}, {"node", "<table>", ""}, {"digger", "<Player>", ""}
		}
	},
	
	on_timer = {
		default_func = function(pos, elapsed) end,
		args = {
			{"pos", "<table>", ""}, {"elapsed", "<string>", ""}
		}
	},
	
	on_recieve_fields = {
		default_func = function(pos, formname, fields, sender) end,
		args = {
			{"pos", "<table>", ""}, {"formname", "<string>", ""}, {"fields", "<table>", ""}, {"sender", "<Player>", ""}
		}
	},
	
	allow_metadata_inventory_move = {
		default_func = function(pos, from_list, from_index, to_list, to_index, count, player) return count end,
		args = {
			{"pos", "<table>", ""}, {"from_list", "<string>", ""},
			{"from_index", "<number>", ""}, {"to_list", "<string>", ""}, {"to_index", "<number>", ""},
			{"count", "<number>", ""}, {"player","<Player>", ""}
		}
	},
	
	allow_metadata_inventory_put = {
		default_func = function(pos, listname, index, stack, player) return stack:get_count() end,
		args = {
			{"pos", "<table>", ""}, {"listname", "<string>", ""},
			{"index", "<number>", ""}, {"stack", "<number>", ""},
			{"player", "<Player>", ""}
		}
	},
	
	allow_metadata_inventory_take = {
		default_func = function(pos, listname, index, stack, player) return stack:get_count() end,
		args = {
			{"pos", "<table>", ""}, {"listname", "<string>", ""},
			{"index", "<number>", ""}, {"stack", "<number>", ""},
			{"player", "<Player>", ""}
		}
	},
	
	on_metadata_inventory_move = {
		default_func = function(pos, from_list, from_index, to_list, to_index, count, player) end,
		args = {
			{"pos", "<table>", ""}, {"from_list", "<string>", ""},
			{"from_index", "<number>", ""}, {"to_list", "<string>", ""}, {"to_index", "<number>", ""},
			{"count", "<number>", ""}, {"player", "<Player>", ""}
		}
	},
	
	on_metadata_inventory_put = {
		default_func = function(pos, listname, index, stack, player) end,
		args = {
			{"pos", "<table>", ""}, {"listname", "<string>", ""},
			{"index", "<number>", ""}, {"stack", "<number>", ""}, {"player", "<Player>", ""}
		}
	},
	
	on_metadata_inventory_take = {
		default_func = function(pos, listname, index, stack, player) end,
		args = {
			{"pos", "<table>", ""}, {"listname", "<string>", ""},
			{"index", "<number>", ""}, {"stack", "<number>", ""}, {"player", "<Player>", ""}
		}
	},
	
	after_place_node = {
		default_func = function(pos, placer, itemstack, pointed_thing) end,
		args = {
			{"pos", "<table>", ""}, {"placer", "<Player>", ""}, {"itemstack", "<ItemStack>", ""}, {"pointed_thing", "<table>", ""}
		}
	},
	
	can_dig = {
		default_func = function(pos, oldnode, oldmetadata, digger) return true end,
		args = {
			{"pos", "<table>", ""}, {"oldnode", "<table>", ""}, {"oldmetadata", "<table>", ""}, {"digger", "<Player>", ""}
		}
	},
	
	after_dig_node = {
		default_func = function(pos, oldnode, oldmetadata, digger) end,
		args = {
			{"pos", "<table>", ""}, {"oldnode", "<table>", ""}, {"oldmetadata", "<table>", ""}, {"digger", "<Player>", ""}
		}
	},
	
	on_rightclick = {
		default_func = function(pos, node, clicker, itemstack, pointed_thing) end,
		args = {
			{"pos", "<table>", ""}, {"node", "<table>", ""}, {"clicker", "<player>", ""},
			{"itemstack", "<ItemStack>", ""}, {"pointed_thing", "<table>", ""}
		}
	},
	
	on_secondary_use = {
		default_func = function(itemstack, dropper, pos) end,
		args = {
			{"itemstack", "<ItemStack>", ""}, {"dropper", "<Player>", ""}, {"pos", "<table>", ""}
		}
	},
	
	on_flood = {
		default_func = function(pos, oldnode, newnode) end,
		args = {
			{"pos", "<table>", ""}, {"oldnode", "<table>", ""}, {"newnode", "<table>", ""}
		}
	},
	
	preserve_metadata = {
		default_func = function(pos, oldnode, oldmeta, drops) end,
		args = {
			{"pos", "<table>", ""}, {"oldnode", "<table>", ""}, {"oldmeta", "<MetaDataRef>", ""}, {"drops", "<table>", ""}
		}
	},
	
	on_blast = {
		default_func = function(pos, intensity) minetest.set_node(pos, {name="air"}) end, --remove node
		args = {
			{"pos", "<table>", ""}, {"intensity", "<number>", ""}
		}
	},
}
local sorted_callbacks = {}
for k, v in pairs(callbacks) do
	table.insert(sorted_callbacks, k)
end

table.sort(sorted_callbacks)

for k, name in pairs(sorted_callbacks) do
	local params = {}
	for i, v in ipairs(callback_data[name].args) do
		table.insert(params, {v[1], v[2], ""})
	end
	
	morphinggrid.register_grid_function_type("before_grid_item_"..name, "before-grid-item-"..name:gsub("_","-"), {
		params = params,
		args = {{"cancel", "<boolean>", "If true, the callback will be canceled."},
				{"args", "<table>", "An indexed table of values to return from the callback. See lua_api.txt for more details on the '"..
					name.."' callback."}}
	})
	
	table.insert(params, {"canceled", "<boolean>", "Returns true if the callback was canceled."})
	morphinggrid.register_grid_function_type("after_grid_item_"..name, "after-grid-item-"..name:gsub("_","-"), {
		params = params,
		args = {}
	})
end

morphinggrid.registered_griditems = {}

local function get_callbacks(exclude)
	local _callbacks = {}
	for k, v in pairs(callbacks) do
		_callbacks[k] = v
	end
	
	--remove excluded callbacks
	for k, v in pairs(exclude) do
		if v == true then
			_callbacks[k] = false
		end
	end
	
	return _callbacks
end

function morphinggrid.register_griditem(name, def)
	if type(def.type) ~= "string" then
		def.type = "craftitem"
	end
	def.name = name
	def.exclude_callbacks = def.exclude_callbacks or {}
	def.griditem_commands = def.griditem_commands or {}
	def.rangers = def.rangers or {}
	def.morph_chance = def.morph_chance or 0
	def.callbacks = get_callbacks(def.exclude_callbacks)
	
	def.morph_behavior = def.morph_behavior or function(player, itemstack)
		return morphinggrid.default_callbacks.griditem.morph_behavior(player, itemstack)
	end
	
	def.allow_prevent_respawn = def.allow_prevent_respawn or function(player, itemstack)
		return morphinggrid.default_callbacks.griditem.allow_prevent_respawn(player, itemstack)
	end
	
	local allowed_item_types = {tool=true,craftitem=true,node=true}
	if not allowed_item_types[def.type] then
		error("item type '"..def.type.."' is invalid.")
	end
	
	
	--Add command presets
	def.griditem_command_presets = def.griditem_command_presets or {}
	for pname, p in pairs(def.griditem_command_presets) do
		if morphinggrid.griditem_cmd_presets[pname] then
			if p == true then
				for cname, c in pairs(def.griditem_cmd_presets[pname]) do
				  def.griditem_commands[cname] = c
				end
			end
		else
			error("'"..pname.."' is not an existing preset.")
		end
	end
	
	--Add default commands to the griditem.
	def.griditem_commands.help = {
		description = "Lists all commands for the griditem.",
		func = function(name)
		    minetest.chat_send_player(name,"Commands for: "..def.description or name)
		    for cmd,t in pairs(def.griditem_commands) do
				minetest.chat_send_player(name,cmd.." "..(t.params or "").." | "..(t.description or name))
		    end
		end
	}
	
	--callbacks
	for k, v in pairs(get_callbacks(def.exclude_callbacks)) do
		def[k] = def[k] or callback_data[k].default_func
	end
	
	for k, v in pairs(def) do
		if callbacks[k] and type(v) == "function" then
			local func = v
			def[k] = function(...)
				local result
				
				local params = {...}
				local grid_params = {}
				for i, v in ipairs(callback_data[k].args) do
					grid_params[v[1]] = params[i]
				end
				
			    local grid_args = morphinggrid.call_grid_functions("before_grid_item_"..k, grid_params)
				
				if not grid_args.cancel then
					result = func(...)
				else
					grid_params.canceled = true
					result = unpack(grid_args.args or {})
				end
				
				morphinggrid.call_grid_functions("after_grid_item_"..k)
				return result
			end
		end
	end
	
	--register griditem
	morphinggrid.registered_griditems[name] = def
	
	--register item
	if type(def.register_item) ~= "boolean" then
		def.register_item = true
	end
	
	if def.register_item == true then
		minetest["register_"..def.type](name, def)
	end
end

--default callbacks
morphinggrid.default_callbacks.griditem = {}

function morphinggrid.default_callbacks.griditem.morph_behavior(player, itemstack)
	local def = morphinggrid.registered_griditems[itemstack:get_name()]
	local r = round(math.random(0, def.morph_chance))
	minetest.chat_send_all(r..", "..def.morph_chance)
	
	--get ranger index
	local ranger_count = 0
	for i, _ in ipairs(def.rangers) do
		ranger_count = ranger_count + 1
	end
	local ranger_index = round(math.random(1, ranger_count))
	
	--attempt to morph
	if def.morph_chance == 0 then
		return false
	end
	
	if r == 1 then
		morphinggrid.morph(player, def.rangers[ranger_index])
	else
		minetest.chat_send_player(player:get_player_name(), "The grid item could not execute a successful morph. "..
			"Try again or use one of the listed morphers to eliminate this problem. ")
			
		for k, v in pairs(search_for_morphers(itemstack:get_name())) do
			minetest.chat_send_player(player:get_player_name(), (v.description or v.name)..", ["..k.."]")
		end
	end
	
	return true
end

function morphinggrid.default_callbacks.griditem.allow_prevent_respawn(player, itemstack)
	local def = morphinggrid.registered_griditems[itemstack:get_name()]
	local count = 0
	for _, _ in ipairs(def.rangers) do
		count = count + 1
	end
	
	if count < 1 then
		return true
	end
	
	for k, ranger in ipairs(def.rangers) do
		local rangerdata = morphinggrid.get_rangerdata(player, ranger)
		if rangerdata:has_energy() then
			return true
		end
	end
	return false
end

function search_for_morphers(griditem_name)
	local morphers_found = {}
	for morpher, morpherdef in pairs(morphinggrid.registered_morphers) do
		if contains_value(morpherdef.griditems, griditem_name) then
			morphers_found[morpher] = morpherdef
		end
	end
	
	return morphers_found
end

function contains_value(t, value)
	local values_to_keys = {}
	for i, v in ipairs(t) do
		values_to_keys[v] = true
	end
	
	return values_to_keys[value] ~= nil 
end

function round(number)
	local floored = math.floor(number)
	local remainder = number - floored
	if remainder < 0.5 then
		return floored
	else
		return floored + 1
	end
end