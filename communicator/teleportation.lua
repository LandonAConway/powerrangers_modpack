communicator.teleportation = {}

minetest.register_chatcommand("cmc_teleport_pos", {
  params = "<pos> (x,y,z)",
  description = "Teleports player to specified position.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    
    if communicator.player_has_communicator(player) then
      local cmc = communicator.registered_communicators[player:get_inventory():get_stack("communicators_main", 1):get_name()]
      
      if cmc.teleportation then
        local pos = player:get_pos()
        local meta = player:get_meta()
        
        local to_pos = minetest.string_to_pos(text)
        
        if to_pos ~= nil then
          meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))
          
          local old_pos = pos;
          local new_pos = to_pos;
          local result, message = true, "Teleported to: "..minetest.pos_to_string(to_pos)
          
          if cmc.before_teleport ~= nil then
            result, message = cmc.before_teleport(player, old_pos, new_pos, false)
          end
          
          if result then
            communicator.teleportation.teleport(player, to_pos)
            
            if cmc.after_teleport ~= nil then
              cmc.after_teleport(player, old_pos, new_pos, false)
            end
          end
          
          return result, message
        end
        return false, "Position is not a valid."
      end
      return false, "Communicator does not support teleportation."
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
})

minetest.register_chatcommand("cmc_safe_teleport_pos", {
  params = "<pos> (x,y,z)",
  description = "Safely teleports player near specified position. If the position is in a dangorous spot (i.e. in free fall) you will be teleported to a safe position near it.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    
    if communicator.player_has_communicator(player) then
      local cmc = communicator.registered_communicators[player:get_inventory():get_stack("communicators_main", 1):get_name()]
      
      if cmc.teleportation then
        local pos = player:get_pos()
        local meta = player:get_meta()
        
        local to_pos = minetest.string_to_pos(text)
        
        if to_pos ~= nil then
          local best_pos_a = communicator.teleportation.find_best_pos(to_pos, 2)
          local best_pos_b = communicator.teleportation.find_best_pos(to_pos, 7)
          if best_pos_a ~= nil then
            local old_pos = pos;
            local new_pos = best_pos_a;
            local result, message = true, "Teleported to: "..minetest.pos_to_string(best_pos_a)
            
            if cmc.before_teleport ~= nil then
              result, message = cmc.before_teleport(player, old_pos, new_pos, false)
            end
            
            --teleport player
            if result then
              meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))
              player:set_pos(best_pos_a)

              if cmc.after_teleport ~= nil then
                cmc.after_teleport(player, old_pos, new_pos, false)
              end
            end
          
            return result, message
          elseif best_pos_b ~= nil then
            local old_pos = pos;
            local new_pos = best_pos_b;
            local result, message = true, "Teleported to: "..minetest.pos_to_string(best_pos_b)
            
            if cmc.before_teleport ~= nil then
              result, message = cmc.before_teleport(player, old_pos, new_pos, false)
            end
            
            --teleport player
            if result then
              meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))
              player:set_pos(best_pos_b)
            
              if cmc.after_teleport ~= nil then
                cmc.after_teleport(player, old_pos, new_pos, false)
              end
            end
            
            return result, message
          end
          return false, "There is not enough space for teleportation."
        end
        return false, "Position is not a valid."
      end
      return false, "Communicator does not support teleportation."
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
})

minetest.register_chatcommand("cmc_teleport", {
  params = "<key>",
  description = "Teleports player to position associated with the given key.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    
    if communicator.player_has_communicator(player) then
      local cmc = communicator.registered_communicators[player:get_inventory():get_stack("communicators_main", 1):get_name()]
      
      if cmc.teleportation then
        local pos = player:get_pos()
        local meta = player:get_meta()
        local smeta = player:get_inventory():get_stack("communicators_main", 1):get_meta()
        
        --proposed--
        local positions = minetest.deserialize(smeta:get_string("positions")) or {}
        if positions[text] ~= nil then
          local old_pos = pos;
          local new_pos = positions[text];
          local result, message = true, "Teleported to: "..minetest.pos_to_string(positions[text])
          
          if cmc.before_teleport ~= nil then
            result, message = cmc.before_teleport(player, old_pos, new_pos, false)
          end
          
          --teleport player
          if result then
            meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))
            player:set_pos(positions[text])
            
            if cmc.after_teleport ~= nil then
              cmc.after_teleport(player, old_pos, new_pos, false)
            end
          end
          
          return result, message
        end
        return false, "Position key does not exist."
        
        --old--
--        local to_pos = communicator.teleportation.locations_get_pos(player, text)
--        
--        if text ~= nil and communicator.teleportation.locations_exists(player, text) then
--          meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))
--          
--          communicator.teleportation.teleport(player, to_pos)
--          return true, "Teleported to: "..minetest.pos_to_string(to_pos)
--        else
--          return false, "Position key does not exist."
--        end
      end
      return false, "Communicator does not support teleportation."
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
})

minetest.register_chatcommand("cmc_teleport_to_player", {
  params = "<player> (x,y,z)",
  description = "Teleports player to specified player.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    
    if communicator.player_has_communicator(player) then
      local cmc = communicator.registered_communicators[player:get_inventory():get_stack("communicators_main", 1):get_name()]
      
      if cmc.teleportation then
        local pos = player:get_pos()
        local meta = player:get_meta()
        
        if minetest.player_exists(text) then
          for _, plr in ipairs(minetest.get_connected_players()) do
            if text == plr:get_player_name() then
              local to_pos = plr:get_pos()
              
              local best_pos_a = communicator.teleportation.find_best_pos(to_pos, 2)
              local best_pos_b = communicator.teleportation.find_best_pos(to_pos, 7)
              if best_pos_a ~= nil then
                local old_pos = pos;
                local new_pos = best_pos_a;
                local result, message = true, "Teleported to: "..minetest.pos_to_string(best_pos_a)
                
                if cmc.before_teleport ~= nil then
                  result, message = cmc.before_teleport(player, old_pos, new_pos, false)
                end
                
                --teleport player
                if result then
                  meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))
                  player:set_pos(best_pos_a)
                  
                  if cmc.after_teleport ~= nil then
                    cmc.after_teleport(player, old_pos, new_pos, false)
                  end
                end
          
                return result, message
              elseif best_pos_b ~= nil then
                local old_pos = pos;
                local new_pos = best_pos_b;
                local result, message = true, "Teleported to: "..minetest.pos_to_string(best_pos_b)
                
                if cmc.before_teleport ~= nil then
                  result, message = cmc.before_teleport(player, old_pos, new_pos, false)
                end
                
                --teleport player
                if result then
                  meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))
                  player:set_pos(best_pos_b)
                  
                  if cmc.after_teleport ~= nil then
                    cmc.after_teleport(player, old_pos, new_pos, false)
                  end
                end
          
                return result, message
              end
              return false, "There is not enough space for teleportation."
            end
          end
          return false, "Player is not online."
        end
        return false, "Player does not exist."
      end
      return false, "Communicator does not support teleportation."
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
})

minetest.register_chatcommand("cmc_teleport_back", {
  params = "",
  description = "Teleports player back to previous position.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, param)
    local player = minetest.get_player_by_name(name)
    
    if communicator.player_has_communicator(player) then
      local cmc = communicator.registered_communicators[player:get_inventory():get_stack("communicators_main", 1):get_name()]
      
      if cmc.teleportation then
        local meta = player:get_meta()
        
        local pos = minetest.string_to_pos(meta:get_string("cmc_last_pos"))
        
        if pos ~= nil then
          local old_pos = player:get_pos();
          local new_pos = pos;
          local result, message = true, "Teleported to: "..minetest.pos_to_string(pos)
          
          if cmc.before_teleport ~= nil then
            result, message = cmc.before_teleport(player, old_pos, new_pos, false)
          end
          
          --teleport player
          if result then
            meta:set_string("cmc_last_pos", minetest.pos_to_string(player:get_pos()))
            communicator.teleportation.teleport(player, pos)
            
            if cmc.after_teleport ~= nil then
              cmc.after_teleport(player, old_pos, new_pos, true)
            end
          end
          
          return result, message
        end
        return false, "No position set"
      end
      return false, "Communicator does not support teleportation."
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
})

minetest.register_chatcommand("cmc_teleportation_add_pos", {
  params = "<key>",
  description = "Saves players current location with specified key so it can be teleported to.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    
    if communicator.player_has_communicator(player) then
      local cmc = communicator.registered_communicators[player:get_inventory():get_stack("communicators_main", 1):get_name()]
      
      if cmc.teleportation then
        local pos = player:get_pos()
        local meta = player:get_meta()
        local stack = player:get_inventory():get_stack("communicators_main", 1)
        local smeta = stack:get_meta()
        
        if text ~= nil and text ~= "" then
          if not string.find(text, "|") and not string.find(text, "=") then
            --proposed--
            local positions = minetest.deserialize(smeta:get_string("positions")) or {}
            positions[text] = pos
            smeta:set_string("positions", minetest.serialize(positions))
            player:get_inventory():set_stack("communicators_main", 1, stack)
            
            --old--
--            communicator.teleportation.locations_add_pos(player, pos, text)
            return true, "'"..text.."' added. "
          end
          return false, "Key cannot contain these characters: '|='."
        end
        return false, "Enter a key."
      end
      return false, "Communicator does not support teleportation."
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
})

minetest.register_chatcommand("cmc_teleportation_remove_pos", {
  params = "<key>",
  description = "Deletes location by specified key.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    
    if communicator.player_has_communicator(player) then
      local cmc = communicator.registered_communicators[player:get_inventory():get_stack("communicators_main", 1):get_name()]
      
      if cmc.teleportation then
        local pos = player:get_pos()
        local meta = player:get_meta()
        local stack = player:get_inventory():get_stack("communicators_main", 1)
        local smeta = stack:get_meta()
        
        if text ~= nil and text ~= "" then
          --proposed--
          local positions = minetest.deserialize(smeta:get_string("positions")) or {}
          positions[text] = nil
          smeta:set_string("positions", minetest.serialize(positions))
          player:get_inventory():set_stack("communicators_main", 1, stack)
          if positions[text] ~= nil then
            return true, "'"..text.."' removed."
          end
          return false, "Key does not exist."
          
          --old--
--          if communicator.teleportation.locations_get_pos(player, text) ~= nil then
--            communicator.teleportation.locations_remove_pos(player, text)
--            return true, "'"..text.."' removed. "
--          else
--            return false, "Key does not exist."
--          end
        end
        return false, "Enter a key."
      end
      return false, "Communicator does not support teleportation."
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
})

minetest.register_chatcommand("cmc_teleportation_get_keys", {
  params = "",
  description = "Lists all of your keys.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    
    if communicator.player_has_communicator(player) then
      local cmc = communicator.registered_communicators[player:get_inventory():get_stack("communicators_main", 1):get_name()]
      
      if cmc.teleportation then
        --proposed--
        local pos = player:get_pos()
        local meta = player:get_meta()
        local stack = player:get_inventory():get_stack("communicators_main", 1)
        local smeta = stack:get_meta()
        local positions = minetest.deserialize(smeta:get_string("positions")) or {}
        
        local keys;
        
        for k, p in pairs(positions) do
          if keys == nil then keys = "" end
          keys = keys..k..", ("..p.x..", "..p.y..", "..p.z..") "
        end
        
        if keys ~= nil then
          return true, keys
        end
        return false, "You have do not have any saved positions."
      
      --old--
--        local t = {}
--        for k, v in pairs(communicator.teleportation.locations_get_positions(player)) do
--          table.insert(t, k)
--        end
--
--        local keys = table.concat(t, ",")
--
--        if keys ~= nil and keys ~= "" then
--          return true, "Position keys: "..keys
--        end
--        return false, "You have not saved any postions."
      end
      return false, "Communicator does not support teleportation."
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
})

minetest.register_chatcommand("cmc_teleportation_get_pos", {
  params = "<key>",
  description = "Shows location by specified key.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    
    if communicator.player_has_communicator(player) then
      local cmc = communicator.registered_communicators[player:get_inventory():get_stack("communicators_main", 1):get_name()]
      
      if cmc.teleportation then
        local pos = player:get_pos()
        local meta = player:get_meta()
        
        if text ~= nil and text ~= "" then
          --proposed--
          local pos = player:get_pos()
          local meta = player:get_meta()
          local stack = player:get_inventory():get_stack("communicators_main", 1)
          local smeta = stack:get_meta()
          local positions = minetest.deserialize(smeta:get_string("positions")) or {}

          if positions[text] ~= nil then
            return true, "Position of '"..text.."' is: "..minetest.pos_to_string(positions[text])
          end
          return false, "Key does not exist."
        --old--
--          if communicator.teleportation.locations_get_pos(player, text) ~= nil then
--            return true, "Position of '"..text.."' is: "..minetest.pos_to_string(communicator.teleportation.locations_get_pos(player, text))
--          end
--          return false, "Key does not exist."
        end
        return false, "Enter a key."
      end
      return false, "Communicator does not support teleportation."
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
})

function communicator.teleportation.teleport(player, pos)
  player:set_pos(pos)
end

function communicator.teleportation.locations_add_pos(player, pos, key)
  local meta = player:get_meta()
  local list = meta:get_string("cmc_locations_list")
  if list ~= nil or list ~= "" then
    local list_table = splitstr(list, "|")
    if communicator.teleportation.locations_exists(player, key) == true then
      list_table = communicator.teleportation.table_remove_pos(list_table, key)
      table.insert(list_table, key.."="..minetest.pos_to_string(pos))
    else
      table.insert(list_table, key.."="..minetest.pos_to_string(pos))
    end
    
    meta:set_string("cmc_locations_list", table.concat(list_table, "|"))
    return true
  else
    meta:set_string("cmc_locations_list", key.."="..minetest.pos_to_string(pos))
    return true
  end
  return false
end

function communicator.teleportation.locations_remove_pos(player, key)
  local meta = player:get_meta()
  local list = meta:get_string("cmc_locations_list")
  
  if list ~= nil or list ~= "" then
    local list_table = splitstr(list, "|")
    
    for i, v in ipairs(list_table) do
      if string.find(v, key.."=") then
        table.remove(list_table, i)
      end
    end
    
    meta:set_string("cmc_locations_list", table.concat(list_table, "|"))
    return true
  else
    return false
  end
  
  return false
end

function communicator.teleportation.table_remove_pos(t, key)
  for i, v in ipairs(t) do
    if string.find(v, key.."=") then
      table.remove(t, i)
    end
  end
  
  return t
end

function communicator.teleportation.locations_get_positions(player)
  local meta = player:get_meta()
  local list = meta:get_string("cmc_locations_list")
  local list_table = splitstr(list, "|")
  local t = {}
  
  for i, v in ipairs(list_table) do
    if string.find(v, "=") then
      local data = splitstr(v, "=")
      t[data[1]] = data[2]
    end
  end
  
  return t
end

function communicator.teleportation.locations_get_pos(player, key)
  local meta = player:get_meta()
  local list = meta:get_string("cmc_locations_list")
  local list_table = splitstr(list, "|")
  
  for i, v in ipairs(list_table) do
    if string.find(v, key.."=") then
      local data = splitstr(v, "=")
      return minetest.string_to_pos(data[2])
    end
  end
  
  return nil
end

function communicator.teleportation.locations_exists(player, key)
  local meta = player:get_meta()
  local list = meta:get_string("cmc_locations_list")
  local list_table = splitstr(list, "|")
  
  for i, v in ipairs(list_table) do
    if string.find(v, key.."=") then
      return true
    end
  end
  
  return false
end

function communicator.teleportation.get_node_positions_inside_area(pos, span)
  local first = vector.new(pos.x + span, pos.y + span, pos.z + span)
  local last = vector.new(pos.x - span, pos.y - span, pos.z - span)
  return communicator.teleportation.add_pos(first, vector.new(first.x, first.y, first.z), last)
end

function communicator.teleportation.add_pos(first_pos, current_pos, last_pos, list)
  if list == nil then list = {} end
  
  local x_amount = first_pos.x - last_pos.x +1
  local y_amount = first_pos.y - last_pos.y +1
  local z_amount = first_pos.z - last_pos.z +1
  
  for i = 1, z_amount do
    current_pos.y = first_pos.y
    for i = 1, y_amount do
      current_pos.x = first_pos.x
      for i = 1, x_amount do
        table.insert(list, vector.new(current_pos.x, current_pos.y, current_pos.z))
        current_pos.x = current_pos.x - 1
      end
      current_pos.y = current_pos.y - 1
    end
    current_pos.z = current_pos.z - 1
  end
  
  return list
end

function communicator.teleportation.find_best_pos(pos, radius)
  local positions = communicator.teleportation.get_node_positions_inside_area(pos, radius)
  for _, new_pos in ipairs(positions) do
    local node = minetest.get_node(new_pos)
    local node_above = minetest.get_node(vector.new(new_pos.x, new_pos.y + 1, new_pos.z))
    local node_below = minetest.get_node(vector.new(new_pos.x, new_pos.y - 1, new_pos.z))
    if node.name == "air" and node_above.name == "air" then
      if minetest.get_item_group(node_below.name, "cracky") > 0 or
      minetest.get_item_group(node_below.name, "crumbly") > 0 or
      minetest.get_item_group(node_below.name, "choppy") > 0 or
      minetest.get_item_group(node_below.name, "snappy") > 0 or
      minetest.get_item_group(node_below.name, "snowy") > 0 or
      minetest.get_item_group(node_below.name, "water") > 0 then
        local players_nearby = communicator.teleportation.get_players_near(pos, radius)
        if count_table(players_nearby) > 0 then
           for _, plr in ipairs(players_nearby) do
             if vector.distance(plr:get_pos(), new_pos) > 1 then
               return new_pos
             end
           end
        else
           return new_pos
        end
      end
    elseif minetest.get_item_group(node.name, "water") > 0 and minetest.get_item_group(node_above.name, "water") > 0 then
      if minetest.get_item_group(node_below.name, "cracky") > 0 or
      minetest.get_item_group(node_below.name, "crumbly") > 0 or
      minetest.get_item_group(node_below.name, "choppy") > 0 or
      minetest.get_item_group(node_below.name, "snappy") > 0 or
      minetest.get_item_group(node_below.name, "snowy") > 0 or
      minetest.get_item_group(node_below.name, "water") > 0 then
        local players_nearby = communicator.teleportation.get_players_near(pos, radius)
        if count_table(players_nearby) > 0 then
           for _, plr in ipairs(players_nearby) do
             if vector.distance(plr:get_pos(), new_pos) > 1 then
               return new_pos
             end
           end
        else
           return new_pos
        end
      end
    end
  end
  return nil
end

function communicator.teleportation.get_players_near(pos, radius)
  local objs = minetest.get_objects_inside_radius(pos, radius*2)
  local result = {}
  for _, obj in ipairs(objs) do
    if obj:is_player() then
      table.insert(result, obj)
    end
  end
  return result
end

function count_table(input)
  local result = 0
  for _, v in ipairs(input) do
    result = result + 1
  end
  return result
end

function splitstr(input, sep)
  if sep == nil then
    sep = "|"
  end
  local t = {}
  for str in string.gmatch(input, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end