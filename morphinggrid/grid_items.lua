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
		default_func = function(pos, node, puncher, pointed_thing) minetest.node_punch(pos, node, punch, pointed_thing) end,
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

local function get_callbacks(def)
	local _callbacks = {}
	for k, v in pairs(callbacks) do
		_callbacks[k] = v
	end
	
	--remove on_use if needed
	if def.is_morpher then
		_callbacks.on_use = nil
	end
	
	return _callbacks
end

function morphinggrid.register_griditem(name, def)
	if type(def.type) ~= "string" then
		def.type = "craftitem"
	end
	def.name = name
	def.griditem_commands = def.griditem_commands or {}
	
	local allowed_item_types = {tool=true,craftitem=true,node=true}
	if not allowed_item_types[def.type] then
		error("item type '"..def.type.."' is invalid.")
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
	for k, v in pairs(get_callbacks(def)) do
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
	
	
	minetest["register_"..def.type](name, def)
	morphinggrid.registered_griditems[name] = def
end