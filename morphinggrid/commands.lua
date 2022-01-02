minetest.register_chatcommand("morph", {
  params = "<player> <ranger>",
  description = "Morph a player into any ranger.",
  
  privs = {
    interact = true,
    power_rangers = true,
  },
  
  func = function(name, text)
    if text ~= nil and text ~= "" then
      if minetest.check_player_privs(name, { morphinggrid=true }) then
        local params = morphinggrid.split_string(text)
        for _, player in ipairs(minetest.get_connected_players()) do
          if params[1] == player:get_player_name() then
            if params[2] ~= nil then
              local ranger = morphinggrid.registered_rangers[params[2]]
              if ranger ~= nil then
                morphinggrid.morph(player, ranger, {priv_bypass=true})
                return true, "'"..player:get_player_name().."' morphed successfully. (Ranger: "..ranger.description..")"
              end
              return false, "'"..params[2].."' is not a registered ranger."
            end
            return false, "Please enter a ranger name."
          end
        end
        local ranger = morphinggrid.registered_rangers[params[1]]
        if ranger ~= nil then
          morphinggrid.morph(minetest.get_player_by_name(name), ranger, {priv_bypass=true})
          return true
        end
        return false, "Please enter an online player's name, or a ranger name."
      end
      return false, "You don't have permission to run this command (Missing Privileges: morphinggrid)"
    else
      local player = minetest.get_player_by_name(name)
      local inv = morphinggrid.morphers.get_inventory(player)
      if not inv:is_empty("single") then
        local stack = inv:get_stack("single", 1)
        local stackname = stack:get_name()
        if morphinggrid.registered_morphers[stackname] ~= nil then
			local itemstack = morphinggrid.morph_from_morpher(player, stackname, stack) or stack
			inv:set_stack("single", 1, itemstack)
			return true
		elseif morphinggrid.registered_griditems[stackname] ~= nil then
			local def = morphinggrid.registered_griditems[stackname]
			local result, itemstack = def.morph_behavior(player, stack)
			inv:set_stack("single", 1, itemstack or stack)
			if result then
				return true
			end
			return false, "The item placed in the single morpher slot is a grid item but is not capeable of "..
					"morphing a player without a morpher. Use the chat command '/morphers'"
        end
        return false, "The item placed in the single morpher slot is not a morpher. Use the chat command '/morphers'"
      end
      return false, "There is no morpher placed in the single morpher slot. Use the chat command '/morphers'"
    end
  end,
})

minetest.register_chatcommand("demorph", {
  params = "<player>",
  description = "Demorph yourself or any player if you have the 'morphinggrid' priv. Leave <player> empty to demorph yourself.",
    
  privs = {
    interact = true,
    power_rangers = true,
  },
  
  func = function(name, text)
    if text ~= nil and text ~= "" then
      if minetest.check_player_privs(name, { morphinggrid=true }) then
        for _, player in ipairs(minetest.get_connected_players()) do
          if text == player:get_player_name() then
            local result, demorph_info = morphinggrid.demorph(player, {priv_bypass=true})
            if demorph_info.ranger ~= nil then
              return true, "'"..player:get_player_name().."' demorphed successfully. (Ranger: "..demorph_info.ranger.description..")"
            end
            return false, "'"..player:get_player_name().."' is not morphed."
          end
        end
        return false, "Player '"..text.."' is not online or does not exist."
      end
      return false, "You don't have permission to run this command (Missing Privileges: morphinggrid)"
    else
      local player = minetest.get_player_by_name(name)
      if morphinggrid.demorph(player, false) == true then
        return true
      end
    end
  end,
})

minetest.register_chatcommand("ranger", {
  params = "<command>",
  description = "Execute a ranger command.",
  
  privs = {
    interact = true,
    power_rangers = true,
  },
  
  func = function(name,text)
    local player = minetest.get_player_by_name(name)
    local inv = player:get_inventory()
    local ranger = morphinggrid.get_morph_status(player)
    if ranger ~= nil then
      if text ~= nil and text ~= "" then
        local result,message = morphinggrid.execute_ranger_cmd(name,text,ranger)
        return result,message
      end
      return false, "Please enter a command."
    end
    return false, "You are not morphed."
  end
})

function morphinggrid.execute_ranger_cmd(name,text,ranger)
  local params = morphinggrid.split_string(text," ")
  local count = string.len(params[1])+1
  local subtext = string.sub(text,count+1)
  local rangerdef = morphinggrid.registered_rangers[ranger]
  
  local grid_params = {
	player = minetest.get_player_by_name(name),
	pos = minetest.get_player_by_name(name):get_pos(),
	ranger = ranger,
	command = params[1],
	text = subtext,
	canceled = false
  }
  
  local grid_args = morphinggrid.call_grid_functions("before_ranger_command", grid_params)
  
  if grid_args.cancel then
	grid_params.canceled = true
	return false, grid_args.description or "Failed to execute command.", itemstack
  elseif rangerdef.ranger_commands[params[1]] ~= nil then
    local result,message,newitemstack = rangerdef.ranger_commands[params[1]].func(name,subtext,ranger)
    if result == nil then result = true end
    message = message or ""
    return result,message
  end
  
  morphinggrid.call_grid_functions("after_ranger_command", grid_params)
  
  return false, "The command '"..params[1].."' does not exist."
end

minetest.register_chatcommand("morpher", {
  params = "<command>",
  description = "Execute a morpher command.",
  
  privs = {
    interact = true,
    power_rangers = true,
  },
  
  func = function(name,text)
    local player = minetest.get_player_by_name(name)
    local inv = player:get_inventory()
    if morphinggrid.registered_morphers[player:get_wielded_item():get_name()] ~= nil then
      if text ~= nil and text ~= "" then
        local stack = player:get_wielded_item()
        local result,message,itemstack = morphinggrid.execute_morpher_cmd(name,text,stack)
        player:set_wielded_item(itemstack or stack)
        return result,message
      end
      return false, "Please enter a command."
    elseif not inv:is_empty("morphers_main") then
      local stack = inv:get_stack("morphers_main", 1)
      local stackname = stack:get_name()
      if morphinggrid.registered_morphers[stackname] ~= nil then
        if text ~= nil and text ~= "" then
          local result,message,itemstack = morphinggrid.execute_morpher_cmd(name,text,stack)
          inv:set_stack("morphers_main", 1, itemstack)
          return result,message
        end
        return false, "Please enter a command."
      end
      return false, "The item placed in the single morpher slot is not a morpher. Use the chat command '/morphers'"
    end
    return false, "The wielded item is not a morpher and there is no morpher placed in the single morpher slot. Use the chat command '/morphers'"
  end
})

function morphinggrid.execute_morpher_cmd(name,text,itemstack)
  local stack_name = itemstack:get_name()
  local params = morphinggrid.split_string(text," ")
  local count = string.len(params[1])+1
  local subtext = string.sub(text,count+1)
  local morpherdef = morphinggrid.registered_morphers[stack_name]
  
  local grid_params = {
	player = minetest.get_player_by_name(name),
	pos = minetest.get_player_by_name(name):get_pos(),
	itemstack = itemstack,
	command = params[1],
	text = subtext,
	canceled = false
  }
  
  local grid_args = morphinggrid.call_grid_functions("before_morpher_command", grid_params)
  
  if grid_args.cancel then
	grid_params.canceled = true
	return false, grid_args.description or "Morpher failed to execute command.", itemstack
  elseif morpherdef.morpher_commands[params[1]] ~= nil then
    local result,message,newitemstack = morpherdef.morpher_commands[params[1]].func(name,subtext,itemstack)
    if result == nil then result = true end
    message = message or ""
    itemstack = newitemstack or itemstack
    return result,message,itemstack
  end
  
  morphinggrid.call_grid_functions("after_morpher_command", grid_params)
  
  return false, "The command '"..params[1].."' does not exist.", itemstack
end

minetest.register_chatcommand("griditem", {
  params = "<command>",
  description = "Execute a grid item command.",
  
  privs = {
    interact = true,
    power_rangers = true,
  },
  
  func = function(name,text)
    local player = minetest.get_player_by_name(name)
    local inv = player:get_inventory()
    if morphinggrid.registered_griditems[player:get_wielded_item():get_name()] ~= nil then
      if text ~= nil and text ~= "" then
        local stack = player:get_wielded_item()
        local result,message,itemstack = morphinggrid.execute_griditem_cmd(name,text,stack)
        player:set_wielded_item(itemstack or stack)
        return result,message
      end
      return false, "Please enter a command."
    end
    return false, "The wielded item is not a grid item."
  end
})

function morphinggrid.execute_griditem_cmd(name,text,itemstack)
  local stack_name = itemstack:get_name()
  local params = morphinggrid.split_string(text," ")
  local count = string.len(params[1])+1
  local subtext = string.sub(text,count+1)
  local griditemdef = morphinggrid.registered_griditems[stack_name]
  
  local grid_params = {
	player = minetest.get_player_by_name(name),
	pos = minetest.get_player_by_name(name):get_pos(),
	itemstack = itemstack,
	command = params[1],
	text = subtext,
	canceled = false
  }
  
  local grid_args = morphinggrid.call_grid_functions("before_griditem_command", grid_params)
  
  if grid_args.cancel then
	grid_params.canceled = true
	return false, grid_args.description or "Grid Item failed to execute command.", itemstack
  elseif griditemdef.griditem_commands[params[1]] ~= nil then
    local result,message,newitemstack = griditemdef.griditem_commands[params[1]].func(name,subtext,itemstack)
    if result == nil then result = true end
    message = message or ""
    itemstack = newitemstack or itemstack
    return result,message,itemstack
  end
  
  morphinggrid.call_grid_functions("after_griditem_command", grid_params)
  
  return false, "The command '"..params[1].."' does not exist.", itemstack
end

minetest.register_chatcommand("summon_weapon", {
  params = "<weapon_key>",
  description = "Summon a weapon.",
    
  privs = {
    interact = true,
    power_rangers = true,
  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    if text ~= nil and text ~= "" then
      for k, v in pairs(morphinggrid.registered_weapons) do
        if v.weapon_key == text then
          local can_summon, message = morphinggrid.can_summon_weapon(player, k)
          if can_summon then
            local inv = player:get_inventory()
            local stack = ItemStack(k.." 1")
            local leftover = inv:add_item(player:get_wield_list(), stack)
            
            if leftover:get_count() > 0 then
              return false, message or "You cannot summon the "..v.description.." becuase your inventory is full"
            end
            
            return true, message or "You have summoned the '"..v.description.."'."
          end
          return false, message or "You don't have access to this weapon. (Belongs To: "..table.concat(get_ranger_descs(v.rangers), ", ")..")"
        end
      end
      return false, "'"..text.."' is not a registered weapon."
    end
    return false, "Please enter a weapon key."
  end
})

function get_ranger_descs(rangers)
  local t = {}
  for i, v in ipairs(rangers) do
    local ranger = morphinggrid.get_ranger(v)
    
    if morphinggrid.get_ranger_group(v, "hidden") < 1 then
      table.insert(t, ranger.description)
    end
  end
  return t
end

minetest.register_chatcommand("morphing_log", {
  params = "<player>",
  description = "Show information about your or another player's recent morphs and demorphs. Type '#all' for all players.",
  
  privs = {
    interact = true,
    power_rangers = true,
  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    if text ~= nil and text ~= "" then
      if minetest.check_player_privs(name, { morphinggrid=true }) then
        if text == "#all" then
          for i, v in ipairs(morphinggrid.get_morphing_log()) do
            minetest.chat_send_player(name, morphing_info_to_message(v))
          end
        else
          local player_found = false
          for _, _player in ipairs(minetest.get_connected_players()) do
            if text == _player:get_player_name() then
              player_found = true
              for i, v in ipairs(morphinggrid.get_player_morphing_log(player)) do
                minetest.chat_send_player(name, morphing_info_to_message(v))
              end
            end
          end
          if not player_found then
            return false, "Player '"..text.."' is not online or does not exist."
          end
        end
      else
        return false, "You don't have permission to run this command (Missing Privileges: morphinggrid)"
      end
    else
      for i, v in ipairs(morphinggrid.get_player_morphing_log(player)) do
        minetest.chat_send_player(name, morphing_info_to_message(v))
      end
    end
  end
})

function morphing_info_to_message(info)
  local type = ""
  local result = ""
  if info.type == "morph" then
    type = "Morphed"
  elseif info.type == "demorph" then
    type = "Demorphed"
  end
  
  if info.reason == "not_stable" then
    result = "Not Stable"
  elseif info.reason == "successful" then
    result = "Successful"
  end
  
  local t = {
    "["..type.."] "..info.timestamp,
    "Player: "..info.player:get_player_name(),
    "Pos: "..minetest.pos_to_string(info.pos),
    "Ranger: "..info.ranger.name.." ("..info.ranger.description..")",
    "Result: "..result
  }
  
  return table.concat(t, ", ")
end

minetest.register_chatcommand("set_ranger_armor_wear", {
  params = "<player> <ranger> <amount>",
  description = "Sets the ranger armor wear for a specific player.",
  
  privs = {
    interact = true,
    power_rangers = true,
  },
  
  func = function(name, text)
    if text ~= nil and text ~= "" then
      local params = morphinggrid.split_string(text, " ")
      for _, player in ipairs(minetest.get_connected_players()) do
        if player:get_player_name() == params[1] then
          if params[2] ~= nil and params[2] ~= "" then
            local ranger = morphinggrid.registered_rangers[params[2]]
            if ranger ~= nil then
              if params[3] ~= nil and params[3] ~= "" then
                if tonumber(params[3]) then
                  local wear = tonumber(params[3])
                  if wear > -1 and wear < 65536 then
                    if morphinggrid.connections[ranger.name].players[params[1]] == nil then
                      morphinggrid.create_connection(ranger.name, params[1])
                    end
                    morphinggrid.connections[ranger.name].players[params[1]].armor_wear = wear
                    return true, "Wear set to '"..wear.."'."
                  end
                end
                return false, "'"..params[3].."' is not a number."
              end
              return false, "Please enter a number greater than -1 and less than 65536."
            end
            return false, "'"..params[2].."' is not a registered ranger."
          end
          return false, "Enter a ranger name."
        end
      end
      return false, "'"..params[1].."' is not an online, or existing player."
    end
    return false, "Enter a player name."
  end
})

minetest.register_chatcommand("get_weapons", {
	params = "<search_pattern> or <ranger_name>",
	description = "Shows a list of registered weapons based on search pattern, or searches weapons of a specific ranger. Leave empty for full list.",

	privs = {
		interact = true,
		power_rangers = true,
	},

	func = function(name, text)
		local sorted = {}
		for k, v in pairs(morphinggrid.registered_weapons) do
			table.insert(sorted, k)
		end
		table.sort(sorted)
		
		minetest.chat_send_player(name, "===================================")
		minetest.chat_send_player(name, "Weapons:")
		for i, wname in pairs(sorted) do
			local v = morphinggrid.registered_weapons[wname]
			if morphinggrid.registered_rangers[text] then
				local rangers = {}
				for i, v in ipairs(v.rangers) do
					rangers[v] = true
				end
				
				if rangers[text] then
					minetest.chat_send_player(name, v.name..", ("..v.description.."); Weapon Key: "..v.weapon_key..", Blelongs To: "..
					table.concat(get_ranger_descs(v.rangers), ", "))
				end
			elseif text ~= nil or text ~= "" then
				if string.find(v.name, text) then
					minetest.chat_send_player(name, v.name..", ("..v.description.."); Weapon Key: "..v.weapon_key..", Blelongs To: "..
					table.concat(get_ranger_descs(v.rangers), ", "))
				end
			else
				minetest.chat_send_player(name, v.name..", ("..v.description.."); Weapon Key: "..v.weapon_key..", Blelongs To: "..
				table.concat(get_ranger_descs(v.rangers), ", "))
			end
		end
	end
})

minetest.register_chatcommand("get_rangers", {
  params = "<search_pattern>",
  description = "Shows a list of registered rangers based on search pattern. Leave empty for full list.",
  
  privs = {
    interact = true,
    power_rangers = true,
  },
  
  func = function(name, text)
	minetest.chat_send_player(name, "===================================")
	minetest.chat_send_player(name, "Rangers:")
    for i, v in ipairs(get_rangers()) do
      if text ~= nil or text ~= "" then
        if string.find(v.name, text) then
          minetest.chat_send_player(name, v.name..", ("..v.description..")")
        end
      else
        minetest.chat_send_player(name, v.name..", ("..v.description..")")
      end
    end
  end
})

function get_rangers()
  local t = {}
  local names = {}
  for k, v in pairs(morphinggrid.registered_rangers) do
    table.insert(names, k)
  end
  
  table.sort(names, function(a, b) return a:upper() < b:upper() end)
  
  for i, v in ipairs(names) do
    table.insert(t, morphinggrid.registered_rangers[v])
  end
  
  return t
end