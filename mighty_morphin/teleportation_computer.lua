teleportation_computer = {}

function mighty_morphin.teleportation_computer(pos, selected_key, selected_pos)
  local players = table.concat(get_players(), ",")
  if selected_key == nil then selected_key = "" end
  if selected_pos == nil then selected_pos = "" end
  local formspec = "size[16.5,10.5]"..
    "button_exit[13.5,0;3,0.8;exit;Exit]"..
    "button[13.5,1;3,0.8;teleport;Teleport]"..
    "button[13.5,2;3,0.8;teleport_back;Teleport Back]"..
    "label[0,0;Positions (Double click to remove):]"..
    "textlist[0,0.5;4,7;positions;"..table.concat(teleportation_computer.get_key_list(pos), ",").."]"..
    "field[0.3,8.2;4,0.8;key;Key;"..selected_key.."]"..
    "field[0.3,9.2;4,0.8;pos;Pos;"..selected_pos.."]"..
    "button[0,9.75;4,0.8;add_pos;Add]"..
    "label[4.5,0;Online Players (Double click to move):]"..
    "textlist[4.5,0.5;4,10;players;"..players.."]"..
    "label[9,0;Teleport these players (Double click to remove):]"..
    "textlist[9,0.5;4,10;selected_players;"..table.concat(teleportation_computer.get_players(pos)).."]"
  return formspec
end

minetest.register_node("mighty_morphin:command_center_teleportation_computer", {
	description = "Teleportation Computer",
	tiles = {
		"command_center_teleportation_computer.png",
		"command_center_counter.png",
		"command_center_counter.png",
		"command_center_counter.png",
		"command_center_counter.png",
		"command_center_counter.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_metal_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
		}
	},
	
	after_place_node = function(pos, placer, itemstack)
    local can_place = minetest.check_player_privs(placer:get_player_name(), {power_rangers = true})
    if not can_place then
      minetest.remove_node(pos)
      minetest.chat_send_player(placer:get_player_name(), "You do not have the power_rangers priv.")
    else
      teleportation_computer.add_pos(pos,"command_center",pos)
    end
  end,
  
  on_rightclick = function(pos, node, clicker, itemstack)
    local can_use = minetest.check_player_privs(clicker:get_player_name(), {power_rangers = true})
    if can_use == true then
      clicker:get_meta():set_string("teleportation_computer:node_pos", minetest.pos_to_string(pos))
      minetest.show_formspec(clicker:get_player_name(), "mighty_morphin:teleportation_computer_formspec", mighty_morphin.teleportation_computer(pos))
    else
      minetest.chat_send_player(clicker:get_player_name(), "You do not have the power_rangers priv.")
    end
  end,
  
  can_dig = function(pos, player)
    local can_dig = minetest.check_player_privs(player:get_player_name(), {power_rangers = true})
    if can_dig == true then
      return true
    else
      minetest.chat_send_player(player:get_player_name(), "You do not have the power_rangers priv.")
      return false
    end
  end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
  if formname == "mighty_morphin:teleportation_computer_formspec" then
    if fields.positions then
      local event = minetest.explode_textlist_event(fields.positions)
      if (event.type == "DCL") then
        local pos = minetest.string_to_pos(player:get_meta():get_string("teleportation_computer:node_pos"))
        local choosen_location = teleportation_computer.get_key_list(pos)[event.index]
        teleportation_computer.remove_pos(pos, choosen_location)
        minetest.show_formspec(player:get_player_name(), "mighty_morphin:teleportation_computer_formspec", mighty_morphin.teleportation_computer(pos))
      elseif (event.type == "CHG") then
        local pos = minetest.string_to_pos(player:get_meta():get_string("teleportation_computer:node_pos"))
        local choosen_location = teleportation_computer.get_key_list(pos)[event.index]
        local choosen_pos = teleportation_computer.get_pos(pos, choosen_location)
        minetest.show_formspec(player:get_player_name(), "mighty_morphin:teleportation_computer_formspec", mighty_morphin.teleportation_computer(pos, choosen_location, choosen_pos))
      end
    end
    if fields.players then
      local event = minetest.explode_textlist_event(fields.players)
      if (event.type == "DCL") then
        local choosen_player = get_players()[event.index]
        local pos = minetest.string_to_pos(player:get_meta():get_string("teleportation_computer:node_pos"))
        teleportation_computer.add_player(pos, choosen_player)
        minetest.show_formspec(player:get_player_name(), "mighty_morphin:teleportation_computer_formspec", mighty_morphin.teleportation_computer(pos))
      end
    end
    if fields.selected_players then
      local event = minetest.explode_textlist_event(fields.selected_players)
      if (event.type == "DCL") then
        local choosen_player = get_players()[event.index]
        local pos = minetest.string_to_pos(player:get_meta():get_string("teleportation_computer:node_pos"))
        teleportation_computer.remove_player(pos, choosen_player)
        minetest.show_formspec(player:get_player_name(), "mighty_morphin:teleportation_computer_formspec", mighty_morphin.teleportation_computer(pos))
      end
    end
    if fields.add_pos then
      local add_pos = minetest.string_to_pos(fields.pos)
      if add_pos ~= nil then
        local pos = minetest.string_to_pos(player:get_meta():get_string("teleportation_computer:node_pos"))
        teleportation_computer.add_pos(pos,fields.key,add_pos)
        minetest.show_formspec(player:get_player_name(), "mighty_morphin:teleportation_computer_formspec", mighty_morphin.teleportation_computer(pos))
      end
    end
    
    local pos = minetest.string_to_pos(player:get_meta():get_string("teleportation_computer:node_pos"))
    local selected_players = teleportation_computer.get_players(pos)
    if fields.teleport then
      if minetest.string_to_pos(fields.pos) ~= nil then
        local player_count = 0
        for _, selected_player in ipairs(selected_players) do
          if check_if_online(selected_player) then --check if player is still online to prevent crashing.
            local plr = minetest.get_player_by_name(selected_player)
            local meta = plr:get_meta()
            local new_pos = minetest.string_to_pos(fields.pos)
            local best_pos_a = teleportation.find_best_pos(new_pos, 2)
            local best_pos_b = teleportation.find_best_pos(new_pos, 8)
            if check_if_online(selected_player) then --check if player is still online again since teleportation.find_best_pos() can be a slow process.
              if best_pos_a ~= nil then
                meta:set_string("cmc_last_pos", minetest.pos_to_string(plr:get_pos()))
                plr:set_pos(best_pos_a)
                player_count = player_count + 1
                minetest.chat_send_player(selected_player, "Teleported to: "..minetest.pos_to_string(best_pos_a))
              elseif best_pos_b ~= nil then
                meta:set_string("cmc_last_pos", minetest.pos_to_string(plr:get_pos()))
                plr:set_pos(best_pos_b)
                player_count = player_count + 1
                minetest.chat_send_player(selected_player, "Teleported to: "..minetest.pos_to_string(best_pos_b))
              end
            end
          end
        end
        minetest.chat_send_player(player:get_player_name(), player_count.." Players teleported to: "..minetest.pos_to_string(old_pos))
      end
    end
    if fields.teleport_back then
      local player_count = 0
      for _, selected_player in ipairs(selected_players) do
        if check_if_online(selected_player) then
          local plr = minetest.get_player_by_name(selected_player)
          local meta = plr:get_meta()
          local old_pos = minetest.string_to_pos(meta:get_string("cmc_last_pos"))
          meta:set_string("cmc_last_pos", minetest.pos_to_string(plr:get_pos()))
          plr:set_pos(old_pos)
          player_count = player_count + 1
          minetest.chat_send_player(selected_player, "Teleported to: "..minetest.pos_to_string(old_pos))
        end
      end
      minetest.chat_send_player(player:get_player_name(), player_count.." Players teleported to: "..minetest.pos_to_string(old_pos))
    end
  end
end)

function teleportation_computer.add_pos(node_pos, key, pos)
  local meta = minetest.get_meta(node_pos)
  if not string.find(key, "|") and not string.find(key, "=") then
    local data = meta:get_string("position_list")
    if data ~= nil and data ~= "" then
      local list = splitstr(data, "|")
      local exists = teleportation_computer.get_pos(node_pos, key)
      if exists ~= nil then
        teleportation_computer.remove_pos(node_pos, key)
        table.insert(list, key.."="..minetest.pos_to_string(pos))
      else
        table.insert(list, key.."="..minetest.pos_to_string(pos))
      end
      meta:set_string("position_list", table.concat(list, "|"))
    else
      meta:set_string("position_list", key.."="..minetest.pos_to_string(pos))
    end
    return true
  end
  return false
end

function teleportation_computer.remove_pos(node_pos, key)
  local meta = minetest.get_meta(node_pos)
  local data = meta:get_string("position_list")
  if data ~= nil and data ~= "" then
    local list = splitstr(data, "|")
    for i, v in ipairs(list) do
      local pos = splitstr(v, "=")
      if pos[1] == key then
        table.remove(list, i)
        meta:set_string("position_list", table.concat(list, "|"))
        return true
      end
    end
   end
   return false
end

function teleportation_computer.get_pos(node_pos, key)
  local meta = minetest.get_meta(node_pos)
  local data = meta:get_string("position_list")
  if data ~= nil and data ~= "" then
    local list = splitstr(data, "|")
    for i, v in ipairs(list) do
      local pos = splitstr(v, "=")
      if pos[1] == key then
        return pos[2]
      end
    end
  end
  return nil
end

function teleportation_computer.get_key_list(node_pos)
  local meta = minetest.get_meta(node_pos)
  local data = meta:get_string("position_list")
  local keys = {}
  if data ~= nil and data ~= "" then
    local list = splitstr(data, "|")
    for li, v in ipairs(list) do
      table.insert(keys, splitstr(v, "=")[1])
    end
  end
  return keys
end

function teleportation_computer.add_player(node_pos, player_name)
  local meta = minetest.get_meta(node_pos)
  local data = meta:get_string("players")
  if data ~= nil and data ~= "" then
    local list = splitstr(data, "|")
    local exists = teleportation_computer.player_exists(node_pos, player_name)
    if not exists then
      table.insert(list, player_name)
    end
    meta:set_string("players", table.concat(list, "|"))
  else
    meta:set_string("players", player_name)
  end
end

function teleportation_computer.remove_player(node_pos, player_name)
  local meta = minetest.get_meta(node_pos)
  local data = meta:get_string("players")
  if data ~= nil and data ~= "" then
    local list = splitstr(data, "|")
    for i, v in ipairs(list) do
      if v == player_name then
        table.remove(list, i)
        meta:set_string("players", table.concat(list, "|"))
        return true
      end
    end
  end
  return false
end

function teleportation_computer.player_exists(node_pos, player_name)
  local meta = minetest.get_meta(node_pos)
  local data = meta:get_string("players")
  if data ~= nil and data ~= "" then
    local list = splitstr(data, "|")
    for i, v in ipairs(list) do
      if v == player_name then
        return true
      end
    end
  end
  return false
end

function teleportation_computer.get_players(node_pos)
  local meta = minetest.get_meta(node_pos)
  local data = meta:get_string("players")
  if data ~= nil and data ~= "" then
    return splitstr(data, "|")
  end
  return {}
end

function get_players()
  local t = {}
  for _, player in ipairs(minetest.get_connected_players()) do
    table.insert(t, player:get_player_name())
  end
  return t
end

function check_if_online(player_name)
  local t = get_players()
  for _, plr in ipairs(t) do
    if plr == player_name then
      return true
    end
  end
  return false
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