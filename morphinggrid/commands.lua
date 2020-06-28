minetest.register_chatcommand("morph", {
  params = "<player> <ranger>",
  description = "Morph a player into any ranger.",
  
  privs = {
    interact = true,
    morphinggrid = true,
    power_rangers = true,
  },
  
  func = function(name, text)
    if text ~= nil and text ~= "" then
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
    else
      return false, "Please enter a player name or a ranger name."
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
          if morphinggrid.can_summon_weapon(player, k) then
            local inv = player:get_inventory()
            local stack = ItemStack(k.." 1")
            local leftover = inv:add_item(player:get_wield_list(), stack)
            
            if leftover:get_count() > 0 then
              return false, "You cannot summon the "..v.description.." becuase your inventory is full"
            end
            
            return true, "You have summoned the '"..v.description.."'."
          end
          return false, "You don't have access to this weapon. (Belongs To: "..table.concat(get_ranger_descs(v.rangers), ", ")..")"
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
  params = "<search_pattern>",
  description = "Shows a list of registered weapons based on search pattern. Leave empty for full list.",
  
  privs = {
    interact = true,
    power_rangers = true,
  },
  
  func = function(name, text)
    for k, v in pairs(morphinggrid.registered_weapons) do
      if text ~= nil or text ~= "" then
        if string.find(v.name, text) then
          minetest.chat_send_player(name, v.name..", ("..v.description.."); Weapon Key: "..v.weapon_key..", Blelongs To: "..table.concat(get_ranger_descs(v.rangers), ", "))
        end
      else
        minetest.chat_send_player(name, v.name..", ("..v.description.."); Weapon Key: "..v.weapon_key..", Blelongs To: "..table.concat(get_ranger_descs(v.rangers), ", "))
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