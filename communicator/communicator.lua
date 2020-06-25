minetest.register_chatcommand("cmc_message", {
  params = "<message>",
  description = "Sends a message to everyone with the 'communicator' priv.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, text)
    if text ~= nil and text ~= "" then
      local player = minetest.get_player_by_name(name)
      communicator.message_rangers(player, text)
    else
      return false, "Enter a message."
    end
  end,
})

minetest.register_chatcommand("cmc_message_player", {
  params = "<player> <message>",
  description = "Sends a message to a specific player.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, param)
    local player = minetest.get_player_by_name(name)
    local sendto, message = param:match("^(%S+)%s(.+)$")
    
    if message ~= nil and message ~= "" then
      if minetest.player_exists(sendto) then
        if not communicator.message_player(player, sendto, message) then
          return false, "Player is not online"
        end
      else
        return false, "Player does not exist."
      end
    else
      return false, "Enter a message."
    end
  end,
})

minetest.register_chatcommand("cmc_message_all", {
  params = "<message>",
  description = "Sends a message to everyone.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, text)
    if text ~= nil and text ~= "" then
      local player = minetest.get_player_by_name(name)
      communicator.message_world(player, text)
    end
  end,
})

minetest.register_chatcommand("cmc_set_nickname", {
  params = "<nickname>",
  description = "Sets the nickname that will be visible to people who do not have the 'communicator' priv.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, text)
    if text ~= nil and text ~= "" then
      local player = minetest.get_player_by_name(name)
      local meta = player:get_meta()
      meta:set_string("communicator_nickname", text)
      return true, "Nickname set to '"..text.."'."
    else
      return false, "Enter a nickname."
    end
  end,
})

minetest.register_chatcommand("cmc_clear_nickname", {
  params = "",
  description = "Clears the nickname.",
  
  privs = {
    interact = true,
    power_rangers = true,
    communicator = true,
  },
  
  func = function(name, text)
    local player = minetest.get_player_by_name(name)
    local meta = player:get_meta()
    meta:set_string("communicator_nickname", "")
    return true, "Nickname cleared."
  end,
})

function communicator.message_rangers(player, text)
  for _, plr in ipairs(minetest.get_connected_players()) do
    if minetest.check_player_privs(plr:get_player_name(), { communicator=true }) then
      minetest.chat_send_player(plr:get_player_name(), "<"..player:get_player_name().."@Communicator> "..text)
    end
  end
end

function communicator.message_player(player, to, text)
  local meta = player:get_meta()
  local ranger_def = morphinggrid.registered_rangers[morphinggrid.get_last_morph_status(player)] or { description="" }
  local ranger = ranger_def.description:gsub("%s+", "_")
  local communicator_nickname = meta:get_string("communicator_nickname")
  
  for _, plr in ipairs(minetest.get_connected_players()) do
    if plr:get_player_name() == to then
      if communicator_nickname ~= nil and communicator_nickname ~= "" then
        minetest.chat_send_player(player:get_player_name(), "<"..communicator_nickname.."@MMPR_Rangers> "..text)
        minetest.chat_send_player(to, "<"..communicator_nickname.."@MMPR_Rangers> "..text)
        return true
      else
        if ranger ~= nil and ranger ~= "" then
          minetest.chat_send_player(player:get_player_name(), "<"..ranger.."@MMPR_Rangers> "..text)
          minetest.chat_send_player(to, "<"..ranger.."@MMPR_Rangers> "..text)
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

function communicator.message_world(player, text)
  local meta = player:get_meta()
  local ranger_def = morphinggrid.registered_rangers[morphinggrid.get_last_morph_status(player)] or { description="" }
  local ranger = ranger_def.description:gsub("%s+", "_")
  local communicator_nickname = meta:get_string("communicator_nickname")
  
  if communicator_nickname ~= nil and communicator_nickname ~= "" then
    minetest.chat_send_all("<"..communicator_nickname.."@MMPR_Rangers> "..text)
  else
    if ranger ~= nil and ranger ~= "" then
      minetest.chat_send_all("<"..ranger.."@MMPR_Rangers> "..text)
    else
      minetest.chat_send_all("<"..player:get_player_name().."> "..text)
    end
  end
end