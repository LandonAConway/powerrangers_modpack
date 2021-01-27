communicator.cmd_presets.basic = {}

communicator.cmd_presets.basic.message = {
  params = "<message>",
  description = "Sends a message to everyone with the 'communicator' priv.",
  
--  privs = {
--    interact = true,
--    power_rangers = true,
--    communicator = true,
--  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    local inv = player:get_inventory()
    local stack = inv:get_stack("communicators_main", 1)
  
    if inv:is_empty("communicators_main") == false then
      if communicator.registered_communicators[stack:get_name()] ~= nil then
        if text ~= nil and text ~= "" then
          local player = minetest.get_player_by_name(name)
          communicator.message_rangers(player, text, stack)
          return true
        else
          return false, "Enter a message."
        end
      end
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
}


communicator.cmd_presets.basic.message_player = {
  params = "<player> <message>",
  description = "Sends a message to a specific player.",
  
--  privs = {
--    interact = true,
--    power_rangers = true,
--    communicator = true,
--  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    local sendto, message = text:match("^(%S+)%s(.+)$")
    local inv = player:get_inventory()
    local stack = inv:get_stack("communicators_main", 1)
    
    if inv:is_empty("communicators_main") == false then
      if communicator.registered_communicators[stack:get_name()] ~= nil then
        if message ~= nil and message ~= "" then
          if minetest.player_exists(sendto) then
            if not communicator.message_player(player, sendto, message, stack) then
              return false, "Player is not online"
            else
              return true
            end
          else
            return false, "Player does not exist."
          end
        else
          return false, "Enter a message."
        end
      end
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
}


communicator.cmd_presets.basic.message_all = {
  params = "<message>",
  description = "Sends a message to everyone.",
  
--  privs = {
--    interact = true,
--    power_rangers = true,
--    communicator = true,
--  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    local inv = player:get_inventory()
    local stack = inv:get_stack("communicators_main", 1)
    
    if inv:is_empty("communicators_main") == false then
      if communicator.registered_communicators[stack:get_name()] ~= nil then
        if text ~= nil and text ~= "" then
          local player = minetest.get_player_by_name(name)
          communicator.message_world(player, text, stack)
          return true
        end
      end
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
}


communicator.cmd_presets.basic.set_nickname = {
  params = "<nickname>",
  description = "Sets the nickname that will be visible to people who do not have the 'communicator' priv.",
  
--  privs = {
--    interact = true,
--    power_rangers = true,
--    communicator = true,
--  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    local inv = player:get_inventory()
    local stack = inv:get_stack("communicators_main", 1)
    
    if inv:is_empty("communicators_main") == false then
      if communicator.registered_communicators[stack:get_name()] ~= nil then
        if text ~= nil and text ~= "" then
          local meta = stack:get_meta()
          meta:set_string("communicator_nickname", text)
          inv:set_stack("communicators_main", 1, stack)
          return true, "Nickname set to '"..text.."'.", stack
        else
          return false, "Enter a nickname."
        end
      end
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
}


communicator.cmd_presets.basic.clear_nickname = {
  params = "",
  description = "Clears the nickname.",
  
--  privs = {
--    interact = true,
--    power_rangers = true,
--    communicator = true,
--  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    local inv = player:get_inventory()
    local stack = inv:get_stack("communicators_main", 1)
    
    if inv:is_empty("communicator_main") == false then
      if communicator.registered_communicators[stack:get_name()] ~= nil then
        local meta = stack:get_meta()
        meta:set_string("communicator_nickname", "")
        inv:set_stack("communicators_main", 1, stack)
        return true, "Nickname cleared.", stack
      end
    end
    return false, "You do not have a communicator in the communicator slot."
  end,
}


function communicator.message_rangers(player, text, stack)
  local cmc = communicator.registered_communicators[stack:get_name()]
  local channel = communicator.registered_channels[cmc.channel]
  
  for _, plr in ipairs(minetest.get_connected_players()) do
    --if minetest.check_player_privs(plr:get_player_name(), { communicator=true }) then
    if communicator.can_communicate(player, plr) then
      minetest.chat_send_player(plr:get_player_name(), "<"..player:get_player_name().."@"..channel.private_call_sign.."> "..text)
    end
  end
end


function communicator.message_player(player, to, text, stack)
  local meta = stack:get_meta()
  local cmc = communicator.registered_communicators[stack:get_name()]
  local ranger = morphinggrid.registered_rangers[cmc.ranger] or { description="" }
  local name = morphinggrid.split_string(ranger.name,":")[2]
  local ranger_name = name:sub(1,1):upper()..name:sub(2)
  local channel = communicator.registered_channels[cmc.channel]
  local communicator_nickname = meta:get_string("communicator_nickname")
  
  for _, plr in ipairs(minetest.get_connected_players()) do
    if plr:get_player_name() == to then
      if communicator_nickname ~= nil and communicator_nickname ~= "" then
        minetest.chat_send_player(player:get_player_name(), "<"..communicator_nickname.."@"..channel.public_call_sign.."> "..text)
        minetest.chat_send_player(to, "<"..communicator_nickname.."@"..channel.public_call_sign.."> "..text)
        return true
      else
        if ranger_name ~= nil and ranger_name ~= "" then
          minetest.chat_send_player(player:get_player_name(), "<"..ranger_name.."@"..channel.public_call_sign.."> "..text)
          minetest.chat_send_player(to, "<"..ranger_name.."@"..channel.public_call_sign.."> "..text)
          return true
        else
          minetest.chat_send_player(player:get_player_name(), "<"..player:get_player_name().."> "..text)
          minetest.chat_send_player(to, "<"..player:get_player_name().."> "..text)
          return true
        end
      end
    end
  end
  return false
end


function communicator.message_world(player, text, stack)
  local meta = stack:get_meta()
  local cmc = communicator.registered_communicators[stack:get_name()]
  local ranger = morphinggrid.registered_rangers[cmc.ranger] or { description="" }
  local name = morphinggrid.split_string(ranger.name,":")[2]
  local ranger_name = name:sub(1,1):upper()..name:sub(2)
  local channel = communicator.registered_channels[cmc.channel]
  local communicator_nickname = meta:get_string("communicator_nickname")
  
  if communicator_nickname ~= nil and communicator_nickname ~= "" then
    minetest.chat_send_all("<"..communicator_nickname.."@"..channel.public_call_sign.."> "..text)
  else
    if ranger_name ~= nil and ranger_name ~= "" then
      minetest.chat_send_all("<"..ranger_name.."@"..channel.public_call_sign.."> "..text)
    else
      minetest.chat_send_all("<"..player:get_player_name().."> "..text)
    end
  end
end

function communicator.player_has_communicator(player)
  local inv = player:get_inventory()
  local stack = inv:get_stack("communicators_main", 1)
  local cmc = communicator.registered_communicators[stack:get_name()]
  
  if cmc ~= nil then
    return true
  end
  return false
end

function communicator.can_communicate(player1, player2)
  local inv1 = player1:get_inventory()
  local stack1 = inv1:get_stack("communicators_main", 1)
  local cmc1 = communicator.registered_communicators[stack1:get_name()]
  
  --player1 has a communicator
  if cmc1 ~= nil then
    local inv2 = player2:get_inventory()
    local stack2 = inv2:get_stack("communicators_main", 1)
    local cmc2 = communicator.registered_communicators[stack2:get_name()]
    
    --player2 has a communicator
    if cmc2 ~= nil then
      --both have the same channel
      if cmc1.channel == cmc2.channel then
        return true
      end
    end
  end
  return false
end