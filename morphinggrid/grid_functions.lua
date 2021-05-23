morphinggrid.grid_functions = morphinggrid.grid_functions or {}
morphinggrid.grid_function_types = morphinggrid.grid_function_types or {}

function morphinggrid.register_grid_function_type(name, desc, hdata)
	if not morphinggrid.grid_functions[name] then
		morphinggrid.grid_functions[name] = {}
		table.insert(morphinggrid.grid_function_types, {name = name, desc = desc, hdata = hdata})
	end
end

local function get_grid_function_type_index(_type)
	for i, v in ipairs(morphinggrid.grid_function_types) do
		if _type == v.name then
			return i
		end
	end
	return 1
end

--register grid function types
morphinggrid.register_grid_function_type("before_morph", "before-morph", {
	params = {
		{"player", "<Player>", "A reference to the player who is morphing or has morphed."},
		{"pos", "<table>", "The position of the player who is morphing or has morphed."},
		{"ranger", "<string>", "The name of the ranger associated with the morph."},
		{"itemstack", "<ItemStack>", "A reference to the ItemStack of the morpher involved with the morph. This will be nil if there was no morpher."},
		{"timestamp", "<string>", "The time of the action."}
	},
	
	args = {
		{"cancel", "<boolean>", "If true, the morph will be canceled."},
		{"recheck_privs", "<boolean>", "If true, privs will be re-checked, unless morph_settings overrides the need for privs."},
		{"force_recheck_privs", "<boolean>", "If true, privs will be re-checked regardless of morph_settings."},
		{"reason", "<string>", "A reason for cancelation."},
		{"description", "<string>", "A description for cancelation."}
	}
})

morphinggrid.register_grid_function_type("after_morph", "after-morph", {
	params = {
		{"player", "<Player>", "A reference to the player who is morphing or has morphed."},
		{"pos", "<table>", "The position of the player who is morphing or has morphed."},
		{"ranger", "<string>", "The name of the ranger associated with the morph."},
		{"itemstack", "<ItemStack>", "A reference to the ItemStack of the morpher involved with the morph. This will be nil if there was no morpher."},
		{"timestamp", "<string>", "The time of the action."},
		{"canceled", "<boolean>", "Returns true if the morph was canceled."}
	},
	
	args = {
		
	}
})

morphinggrid.register_grid_function_type("before_demorph", "before-demorph", {
	params = {
		{"player", "<Player>", "A reference to the player who is demorphing or has demorphed."},
		{"pos", "<table>", "The position of the player who is demorphing or has demorphed."},
		{"ranger", "<string>", "The name of the ranger associated with the demorph."},
		{"timestamp", "<string>", "The time of the action."},
		{"morphed", "<boolean>", "Returns true if the player is already morphed."}
	},
	
	args = {
		{"cancel", "<boolean>", "If true, the demorph will be canceled."},
		{"recheck_privs", "<boolean>", "If true, privs will be re-checked, unless demorph_settings overrides the need for privs."},
		{"force_recheck_privs", "<boolean>", "If true, privs will be re-checked regardless of demorph_settings."},
		{"reason", "<string>", "A reason for cancelation."},
		{"description", "<string>", "A description for cancelation."}
	}
})

morphinggrid.register_grid_function_type("on_demorph_attempt", "on-demorph-attempt", {
	params = {
		{"player", "<Player>", "A reference to the player who is demorphing or has demorphed."},
		{"pos", "<table>", "The position of the player who is demorphing or has demorphed."},
		{"ranger", "<string>", "The name of the ranger associated with the demorph."},
		{"timestamp", "<string>", "The time of the action."},
		{"morphed", "<boolean>", "Returns true if the player is already morphed."}
	},
	
	args = {
		
	}
})

morphinggrid.register_grid_function_type("after_demorph", "after-demorph", {
	params = {
		{"player", "<Player>", "A reference to the player who is demorphing or has demorphed."},
		{"pos", "<table>", "The position of the player who is demorphing or has demorphed."},
		{"ranger", "<string>", "The name of the ranger associated with the demorph."},
		{"timestamp", "<string>", "The time of the action."},
		{"canceled", "<boolean>", "Returns true if the demorph was canceled."},
		{"morphed", "<boolean>", "Returns true if the player is already morphed."}
	},
	
	args = {
		
	}
})

morphinggrid.register_grid_function_type("before_morpher_use", "before-morpher-use", {
	params = {
		{"player", "<Player>", "A reference to the player who is using the morpher."},
		{"pos", "<table>", "The position of the player who is using the morpher."},
		{"itemstack", "<ItemStack>", "A reference to the ItemStack of the morpher being used."},
	},
	
	args = {
		{"cancel", "<boolean>", "If true, the action will be canceled."},
		{"reason", "<string>", "A reason for cancelation."},
		{"description", "<string>", "A description for cancelation."}
	}
})

morphinggrid.register_grid_function_type("after_morpher_use", "after-morpher-use", {
	params = {
		{"player", "<Player>", "A reference to the player who is using the morpher."},
		{"pos", "<table>", "The position of the player who is using the morpher."},
		{"itemstack", "<ItemStack>", "A reference to the ItemStack of the morpher being used."},
		{"canceled", "<boolean>", "Returns true if the action was canceled."}
	},
	
	args = {
		
	}
})

morphinggrid.register_grid_function_type("before_morpher_command", "before-morpher-command", {
	params = {
		{"player", "<Player>", "A reference to the player who is using the morpher."},
		{"pos", "<table>", "The position of the player who is using the morpher."},
		{"command", "<string>", "The command that was typed."},
		{"text", "<string>", "The text followed by the command."},
		{"itemstack", "<ItemStack>", "A reference to the ItemStack of the morpher being used."},
	},
	
	args = {
		{"cancel", "<boolean>", "If true, the morpher's function will be canceled."},
		{"reason", "<string>", "A reason for cancelation."},
		{"description", "<string>", "A description for cancelation."}
	}
})

morphinggrid.register_grid_function_type("after_morpher_command", "after-morpher-command", {
	params = {
		{"player", "<Player>", "A reference to the player who is using the morpher."},
		{"pos", "<table>", "The position of the player who is using the morpher."},
		{"command", "<string>", "The command that was typed."},
		{"text", "<string>", "The text followed by the command."},
		{"itemstack", "<ItemStack>", "A reference to the ItemStack of the morpher being used."},
		{"canceled", "<boolean>", "Returns true if the command was canceled."}
	},
	
	args = {
		
	}
})
--end of grid function registeration

local function get_grid_function_desc_list()
	local t = {}
	for i, v in ipairs(morphinggrid.grid_function_types) do
		table.insert(t, v.desc)
	end
	
	return table.concat(t, ",")
end

morphinggrid.grid_funcs_loaded = false
minetest.register_on_mods_loaded(function()
	if not morphinggrid.grid_funcs_loaded then
		for k, v in pairs(morphinggrid.grid_functions) do
			local _type = k
			local funcs = minetest.deserialize(morphinggrid.mod_storage.get_string("funcs_".._type))
			if type(funcs) == "table" then
				for i, func in ipairs(funcs) do
					table.insert(morphinggrid.grid_functions[_type], func)
				end
			end
		end
		
		morphinggrid.grid_funcs_loaded = true
	end
end)

local function save_grid_functions()
	for k, v in pairs(morphinggrid.grid_functions) do
		local _type = k
		local funcs = {}
		
		for i, f in ipairs(morphinggrid.grid_functions[_type]) do
			if type(f.func) == "string" then
				table.insert(funcs, f)
			end
		end
		
		morphinggrid.mod_storage.set_string("funcs_".._type, minetest.serialize(funcs))
	end
end

function morphinggrid.register_grid_function(ftype, def)
	table.insert(morphinggrid.grid_functions[ftype], def)
end

function morphinggrid.call_grid_functions(ftype, grid_params)
	if type(morphinggrid.grid_functions[ftype]) ~= "table" then
		error("'"..ftype.."' is not a type of grid function.")
	end
	
	for _, func_args in ipairs(morphinggrid.grid_functions[ftype]) do
		if type(func_args.func) == "string" then
			local grid_args = {
				_break = false
			}
			
			local code, errMsg = loadstring(func_args.func);
			local success, err = pcall(morphinggrid.execute,code,grid_params,grid_args)
			
			if errMsg then
				minetest.chat_send_all("Grid Function error: .. "..errMsg)
				return {_break = false}
			end
			
			if grid_args._break then
				return grid_args
			end
		end
	end
	
	return {}
end

function morphinggrid.execute(code, grid_params, grid_args)
  local env = morphinggrid.create_env(grid_params, grid_args)
  setfenv(code,env)
  local result = code()
end

function morphinggrid.create_env(grid_params, grid_args)
  local env = {
	grid_params = grid_params,
	grid_args = grid_args,
	
	--functions
	print = function(text, name)
		if type(name) == "string" then
			minetest.chat_send_player(name, text)
		else
			minetest.chat_send_all(text or "")
		end
	end,
	
	call_grid_function = function(_type, _name)
		local func = morphinggrid.grid_functions[_type][_name]
		
		local code, errMsg = loadstring(func_args.func);
		local success, err = pcall(morphinggrid.execute,code,grid_params,grid_args)
	end
  }
  setmetatable(env,{ __index = _G })
  return env
end

--interface & interaction
local function get_func_type_name(index)
	if type(index) == "string" then
		index = tonumber(index)
	end
	
	return (morphinggrid.grid_function_types[index] or morphinggrid.grid_function_types[1]).name
end

local get_function_names = function(index)
	if type(index) == "string" then
		index = tonumber(index)
	end
	
	local t = {}
	local selection = get_func_type_name(index)
	
	for i, v in ipairs(morphinggrid.grid_functions[selection]) do
		table.insert(t, v.name or "untitled")
	end
	
	table.insert(t, "<create new>")
	
	return table.concat(t, ",")
end

function morphinggrid.grid_functions_formspec(selection, index, player)
	if not morphinggrid.mff[player] then
		morphinggrid.mff[player] = {
			selection = 1,
			index = 1,
			name = "",
			code = ""
		}
	end
	
	selection = selection or "1"
	index = index or "1"
	
	if type(selection) == "number" then
		selection = tostring(selection)
	end
	
	if type(index) == "number" then
		index = tostring(index)
	end
	
	local selection_name = get_func_type_name(selection)
	
	local data = morphinggrid.grid_functions[selection_name][tonumber(index)] or {name="",func=""}
	local name = data.name or ""
	local code = data.func or ""
	
	
	local formspec = "formspec_version[4]"..
	"size[20,12]"..
	"textlist[0.5,0.8;5,3.7;selection;"..get_grid_function_desc_list()..";"..selection..";false]"..
	"label[0.5,0.5;Selection:]"..
	"label[0.5,5.2;Functions:]"..
	"textlist[0.5,5.5;5,4.9;functions;"..get_function_names(selection)..";"..index..";false]"..
	"button[0.5,10.7;2.3,0.8;save;Save]"..
	"button[3.2,10.7;2.3,0.8;remove;Remove]"..
	"textarea[6,2.2;13.5,8.2;code;;"..minetest.formspec_escape(code).."]"..
	"label[6,0.5;Name:]"..
	"label[6,1.9;Code:]"..
	"field[6,0.8;13.5,0.6;name;;"..name.."]"..
	"button[14.5,10.7;2.3,0.8;help;Help]"..
	"button_exit[17.2,10.7;2.3,0.8;;Exit]"
	
	return formspec
end

morphinggrid.grid_funcs_help_tree = {}

local function build_help_tree(selection)
	local hdata = morphinggrid.grid_function_types[get_grid_function_type_index(selection)].hdata
	
	--clear help_tree
	morphinggrid.grid_funcs_help_tree = {}
	
	--build help_tree
	table.insert(morphinggrid.grid_funcs_help_tree, {"1", "grid_params", "<table>", "A table containing parameters."})
	for _, data in ipairs(hdata.params) do
		local new_data = {"2"}
		for _, part in ipairs(data) do
			table.insert(new_data, part)
		end
		table.insert(morphinggrid.grid_funcs_help_tree, new_data)
	end
	
	table.insert(morphinggrid.grid_funcs_help_tree, {"1", "grid_args", "<table>", "A table containing arguments."})
	table.insert(morphinggrid.grid_funcs_help_tree, {"2", "_break", "boolean", "If true, all functions after the current one will not execute."})
	for _, data in ipairs(hdata.args) do
		local new_data = {"2"}
		for _, part in ipairs(data) do
			table.insert(new_data, part)
		end
		table.insert(morphinggrid.grid_funcs_help_tree, new_data)
	end
	
	table.insert(morphinggrid.grid_funcs_help_tree, {"1", "print", "<function>", "A wrapper for 'minetest.chat_send_all' and "..
													"'minetest.chat_send_player'. Usage: 'print(<message>)' or 'print(<message>, <player_name>')."})
	
	--return a concated version of help_tree
	local help_tree_concats = {}
	for _, v in ipairs(morphinggrid.grid_funcs_help_tree) do
		local new_v = {}
		for i, part in ipairs(v) do
			if i < 4 then
				table.insert(new_v, part)
			end
		end
		table.insert(help_tree_concats, table.concat(new_v, ","))
	end
	
	local data = table.concat(help_tree_concats, ",")
	return data
end

function morphinggrid.grid_functions_help_formspec(selection, desc)
	selection = selection or morphinggrid.grid_function_types[1].name
	desc = desc or ""
	
	local formspec = "formspec_version[4]"..
	"size[16,12]"..
	"tablecolumns[tree;text;text]"..
	"table[0.2,0.7;15.6,8.5;environment;"..build_help_tree(selection).."]"..
	"button[12.8,11;3,0.8;exit;Exit]"..
	"box[0.2,9.4;15.6,1.4;#0f0f0f]"..
	"textarea[0.2,9.4;15.2,1.4;;;"..desc.."]"..
	"label[0.2,0.4;Lua environment:]"
	
	return formspec
end

minetest.register_chatcommand("grid_functions", {
	params = "",
	description = "Allows players to view and manage grid functions.",
	privs = {server = true, morphinggrid = true},
	func = function(name, text)
		minetest.show_formspec(name, "morphinggrid:grid_functions", morphinggrid.grid_functions_formspec(_, _, name))
	end,
})

morphinggrid.mff = {}

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "morphinggrid:grid_functions" then
		local name = player:get_player_name()
		local selection = morphinggrid.mff[name].selection
		local index = morphinggrid.mff[name].index
		
		local selection_name = get_func_type_name(selection)
		
		if fields.selection then
			local event = minetest.explode_textlist_event(fields.selection)
			if(event.type == "CHG") then
				morphinggrid.mff[name].selection = event.index
				morphinggrid.mff[name].index = 1
			end
			
			minetest.show_formspec(name, "morphinggrid:grid_functions", morphinggrid.grid_functions_formspec(selection, index, name))
		elseif fields.functions then
			local event = minetest.explode_textlist_event(fields.functions)
			if(event.type == "CHG") then
				morphinggrid.mff[name].index = event.index
			end
			
			minetest.show_formspec(name, "morphinggrid:grid_functions", morphinggrid.grid_functions_formspec(selection, index, name))
		elseif fields.save then
			if type(morphinggrid.grid_functions[selection_name][index]) == "table" then
				morphinggrid.grid_functions[selection_name][index].func = fields.code:gsub("/]","]"):gsub("/[","[")
				morphinggrid.grid_functions[selection_name][index].name = fields.name
			else
				morphinggrid.register_grid_function(selection_name, {
					name = fields.name,
					func = fields.code:gsub("/]","]"):gsub("/[","[")
				})
			end
			
			morphinggrid.mff[name].name = fields.name
			morphinggrid.mff[name].code = fields.code:gsub("/]","]"):gsub("/[","[")
			
			save_grid_functions()
			minetest.show_formspec(name, "morphinggrid:grid_functions", morphinggrid.grid_functions_formspec(selection, index, name))
		elseif fields.remove then
			if type(morphinggrid.grid_functions[selection_name][index]) == "table" then
				table.remove(morphinggrid.grid_functions[selection_name], index)
				index = index - 1
				if index < 1 then index = 1 end
			end
			
			save_grid_functions()
			minetest.show_formspec(name, "morphinggrid:grid_functions", morphinggrid.grid_functions_formspec(selection, index, name))
		elseif fields.help then
			minetest.show_formspec(name, "morphinggrid:grid_functions_help", morphinggrid.grid_functions_help_formspec(selection_name))
		end
	end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "morphinggrid:grid_functions_help" then
		local name = player:get_player_name()
		local selection = morphinggrid.mff[name].selection
		local selection_name = morphinggrid.grid_function_types[selection].name
		local index = morphinggrid.mff[name].index
	
		if fields.environment then
			local event = minetest.explode_table_event(fields.environment)
			if(event.type == "CHG") then
				local desc = morphinggrid.grid_funcs_help_tree[event.row][4] or ""
				minetest.show_formspec(name, "morphinggrid:grid_functions_help", morphinggrid.grid_functions_help_formspec(selection_name, desc))
			end
		elseif fields.exit then
			minetest.show_formspec(name, "morphinggrid:grid_functions", morphinggrid.grid_functions_formspec(selection, index, name))
		end
	end
end)