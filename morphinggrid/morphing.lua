dofile(minetest.get_modpath("3d_armor") .. "/api.lua")

morphinggrid.morphing_log = {}

morphinggrid.registered_after_morphs = {}
morphinggrid.registered_after_demorphs = {}

morphinggrid.register_after_morph = function(fn)
  table.insert(morphinggrid.registered_after_morphs, fn)
end

morphinggrid.register_after_demorph = function(fn)
  table.insert(morphinggrid.registered_after_demorphs, fn)
end

function morphinggrid.morph(player, ranger, morph_settings)
  if type(ranger) == "string" then
    local ranger_name = ranger
    ranger = morphinggrid.registered_rangers[ranger_name]
    if ranger == nil then error("'"..ranger_name.."' is not a registered ranger.") end
  end
  
  morph_settings = morphinggrid.configure_morph_settings(morph_settings)
  local morph_info = {}
  
  local player_name = player:get_player_name()
  local can_use = minetest.check_player_privs(player_name, { power_rangers=true })
  
  local rangername_split = morphinggrid.split_string(ranger.name, ":")
  local rangertype = morphinggrid.get_rangertype(rangername_split[1])
  
  --morph info
  morph_info.type = "morph"
  morph_info.player = player
  morph_info.ranger = ranger
  morph_info.pos = player:get_pos()
  morph_info.reason = "unknown"
  morph_info.timestamp = os.date('%Y-%m-%d %H:%M:%S')
  
  if morphinggrid.connections[ranger.name].players[player:get_player_name()] == nil then
    morphinggrid.create_connection(ranger.name, player_name)
  end
  
  local result = false
  
  if morph_settings.priv_bypass then
   can_use = true
  end
  
  if can_use == true then
    local connection = morphinggrid.connections[ranger.name].players[player:get_player_name()]
    if connection.timer > 0 then
      morph_info.reason = "not_stable"
      if morph_settings.chat_messages then
       local time_left = morphinggrid.seconds_to_clock(connection.timer)
       minetest.chat_send_player(player_name, "You cannot morph because these ranger powers are not currently stable."..
       " Please wait some time while the Morphing Grid re-stabelizes these ranger powers."..
       " Approximately: "..time_left.days.." Days, "..time_left.hours.." Hours, "..time_left.minutes.." Minutes, "..time_left.seconds.." Seconds")
      end
      return false, morph_info
    end
    
    local inv = minetest.get_inventory({
      type="detached", name=player_name.."_armor"})
    
    morphinggrid.demorph(player, {}, true)
    
    morphinggrid.connections[ranger.name].players[player:get_player_name()].in_use = true
    
    morphinggrid.set_ranger_meta(player, ranger)
    morphinggrid.set_ranger_abilities(player, ranger)
    
    for k, v in pairs(morph_settings.armor_parts) do
      if v == true then
        local stack = ItemStack(rangername_split[1]..":"..k.."_"..rangername_split[2])
        stack:set_wear(morphinggrid.connections[ranger.name].players[player:get_player_name()].armor_wear)
        inv:add_item("armor", stack)
        armor:save_armor_inventory(player)
        armor:set_player_armor(player)
      end
    end
    
    if ranger.hide_identity then
      player:set_nametag_attributes({text = " "})
    end
    
    if ranger.hide_player or morph_settings.hide_player then
      local meta = player:get_meta()
      meta:set_string("morphinggrid_invis", "true")
      local prop = {
          collide_with_object = false,
          pointable = false,
          makes_footstep_sound = false,
          visual_size = {x = 0, y = 0, z = 0},
      }
      player:set_properties(prop)
    end
    
    if morph_settings.chat_messages then
      minetest.chat_send_player(player_name, "Morph successful. (Ranger: "..ranger.description..")")
    end
    morph_info.reason = "successful"
    result = true
  else
    morph_info.reason = "no_permission"
    morph_settings.log_this = false
    minetest.chat_send_player(player_name, "You don't have permisson to morph (Missing Privileges: power_rangers)")
  end
  
  for k, v in pairs(morphinggrid.registered_after_morphs) do
    morphinggrid.registered_after_morphs[v](player, ranger.name, morph_info)
  end
  
  for i, v in ipairs(morphinggrid.registered_ranger_after_morphs) do
    if v == ranger.name then
      local rd = morphinggrid.get_ranger(v)
      rd.after_morph(player, morph_info)
    end
  end
  
  --Log
  if morph_settings.log_this then
   table.insert(morphinggrid.morphing_log, morph_info)
  end
  
  return result, morph_info
end

function morphinggrid.demorph(player, demorph_settings, is_morphing)
  demorph_settings = morphinggrid.configure_demorph_settings(demorph_settings)
  local demorph_info = {}
  
  local player_name = player:get_player_name()
  local can_use = minetest.check_player_privs(player_name, { power_rangers=true })
  
  local result = false
  
  if is_morphing == nil then is_morphing = false end
  
  local meta = player:get_meta()
  local ranger = morphinggrid.get_ranger(meta:get_string("player_morph_status"))
  
  --demorph info
  demorph_info.type = "demorph"
  demorph_info.player = player
  demorph_info.ranger = ranger
  demorph_info.pos = player:get_pos()
  demorph_info.reason = "unknown"
  demorph_info.timestamp = os.date('%Y-%m-%d %H:%M:%S')
  
  if demorph_settings.priv_bypass then
    can_use = true
  end
  
  if ranger ~= nil then
    if morphinggrid.connections[ranger.name].players[player:get_player_name()] == nil then
      morphinggrid.create_connection(ranger.name, player_name)
    end
  end
  
  if can_use == true then
    if is_morphing == true then
      local inv = minetest.get_inventory({
        type="detached", name=player_name.."_armor"})
      
      local wear = morphinggrid.get_current_ranger_wear(player)
      if wear ~= nil then
        morphinggrid.connections[ranger.name].players[player:get_player_name()].armor_wear = wear
        morphinggrid.connections[ranger.name].players[player:get_player_name()].in_use = false
      end
      
      inv:set_list("armor", {})
      
      armor:save_armor_inventory(player)
      armor:set_player_armor(player)
      
      player:set_nametag_attributes({text = ""})
      
      local is_invisible = meta:get_string("morphinggrid_invis")
      
      if is_invisible == "true" then
        player:set_string("morphinggrid_invis", "false")
        local prop = {
          collide_with_object = true,
          pointable = true,
          makes_footstep_sound = true,
          visual_size = {x = 1, y = 1, z = 1},
        }
        player:set_properties(prop)
      end
      
      if ranger ~= nil then
        local rangername_split = morphinggrid.split_string(ranger.name, ":")
        local rangertype = morphinggrid.get_rangertype(rangername_split[1])
        
        morphinggrid.remove_ranger_abilities(player, ranger)
        morphinggrid.remove_weapons(player, rangertype.weapons)
      end
      
      demorph_info.reason = "successful"
      demorph_settings.log_this = false
      result = true
    else
      if ranger == nil then
        demorph_info.reason = "not_morphed"
        demorph_settings.log_this = false
        minetest.chat_send_player(player_name, "You are not morphed.")
      else
        local inv = minetest.get_inventory({
          type="detached", name=player_name.."_armor"})
          
        local wear = morphinggrid.get_current_ranger_wear(player)
        if wear ~= nil then
          morphinggrid.connections[ranger.name].players[player:get_player_name()].armor_wear = wear
          morphinggrid.connections[ranger.name].players[player:get_player_name()].in_use = false
        end
        
        inv:set_list("armor", {})
        
        armor:save_armor_inventory(player)
        armor:set_player_armor(player)
        
        player:set_nametag_attributes({text = ""})
        
        local is_invisible = meta:get_string("morphinggrid_invis")
        
        if is_invisible == "true" then
          player:set_string("morphinggrid_invis", "false")
          local prop = {
            collide_with_object = true,
            pointable = true,
            makes_footstep_sound = true,
            visual_size = {x = 1, y = 1, z = 1},
          }
          player:set_properties(prop)
        end
        
        local rangername_split = morphinggrid.split_string(ranger.name, ":")
        local rangertype = morphinggrid.get_rangertype(rangername_split[1])
        
        morphinggrid.remove_ranger_abilities(player, ranger)
        morphinggrid.remove_weapons(player, rangertype.weapons)
      
        meta:set_string("player_morph_status", "none")
        
        if demorph_settings.chat_messages then
          minetest.chat_send_player(player_name, "Demorph successful. (Ranger: "..ranger.description..")")
        end
        
        demorph_info.reason = "successful"
        result = true
      end
    end
  else
    demorph_info.reason = "no_permission"
    demorph_settings.log_this = false
    minetest.chat_send_player(player_name, "You don't have permisson to demorph (Missing Privileges: power_rangers)")
  end
  
  local rangername = ""
  if ranger == nil then rangername = "none" else rangername = ranger.name end
  
  if not demorph_settings.voluntary then
    demorph_info.reason = "not_stable"
  end
  
  for i, v in ipairs(morphinggrid.registered_after_demorphs) do
    morphinggrid.registered_after_demorphs[i](player, rangername, demorph_info)
  end
  
  for i, v in ipairs(morphinggrid.registered_ranger_after_demorphs) do
    if v == rangername then
      local rd = morphinggrid.get_ranger(v)
      rd.after_demorph(player, demorph_info)
    end
  end
  
  --Log
  if demorph_settings.log_this then
    table.insert(morphinggrid.morphing_log, demorph_info)
  end
  
  return result, demorph_info
end

function morphinggrid.configure_morph_settings(morph_settings)
  morph_settings = morph_settings or {}
  morph_settings.hide_player = morph_settings.hide_player or false
  morph_settings.priv_bypass = morph_settings.priv_bypass or false
  morph_settings.chat_messages = morph_settings.chat_messages or true
  morph_settings.log_this = morph_settings.log_this or true
  
  morph_settings.armor_parts = morph_settings.armor_parts or {}
  
  if morph_settings.armor_parts.helmet == nil then morph_settings.armor_parts.helmet = true end
  if morph_settings.armor_parts.chestplate == nil then morph_settings.armor_parts.chestplate = true end
  if morph_settings.armor_parts.leggings == nil then morph_settings.armor_parts.leggings = true end
  if morph_settings.armor_parts.boots == nil then morph_settings.armor_parts.boots = true end
  
  return morph_settings
end

function morphinggrid.configure_demorph_settings(demorph_settings)
  demorph_settings = demorph_settings or {}
  demorph_settings.priv_bypass = demorph_settings.priv_bypass or false
  demorph_settings.chat_messages = demorph_settings.chat_messages or true
  demorph_settings.log_this = demorph_settings.log_this or true
  demorph_settings.voluntary = demorph_settings.voluntary or true
  return demorph_settings
end

--Reset player wield hand
minetest.after(0, function()
end)

function morphinggrid.set_ranger_meta(player, ranger)
  local meta = player:get_meta()
  local rangername_split = morphinggrid.split_string(ranger.name, ":")
  local rangertype = morphinggrid.get_rangertype(rangername_split[1])
  
  meta:set_string('player_morph_status', ranger.name)
  meta:set_string('player_last_morph_status', ranger.name)
end

function morphinggrid.set_ranger_abilities(player, ranger)
  --wieldhand
  local inv = player:get_inventory()
  local stack = inv:get_stack("hand", 1)
  local meta = stack:get_meta()
  
  local default_ranger_hand = {
      full_punch_interval = 0.1,
      max_drop_level = 0,
      groupcaps = {
        crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
        snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
        cracky={times={[50]=0.10}, uses=1, maxlevel=50},
        oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=0}
      },
      damage_groups = {fleshy=15},
  }
  
  local tool_capabilities = ranger.abilities.strength or default_ranger_hand
  
  meta:set_tool_capabilities(tool_capabilities)
  inv:set_stack("hand", 1, stack)
end

function morphinggrid.remove_ranger_abilities(player, ranger)
  --wieldhand
  local inv = player:get_inventory()
  local stack = inv:get_stack("hand", 1)
  local meta = stack:get_meta()
  meta:set_tool_capabilities(nil)
  inv:set_stack("hand", 1, stack)
end

function morphinggrid.remove_weapons(player, weapons)
  local inv = player:get_inventory()
  for _, weapon in pairs(weapons) do
    local inv_list = inv:get_list("main")
    for _, stack in pairs(inv_list) do
      if stack:get_name() == weapon then
        inv:remove_item("main", stack)
      end
    end
  end
end

function morphinggrid.get_morph_status(player)
  local meta = player:get_meta()
  local status = meta:get_string('player_morph_status')
  if status ~= "none" and status ~= nil and status ~= "" then
    return status
  else
    return nil
  end
end

function morphinggrid.get_last_morph_status(player)
  local meta = player:get_meta()
  local status = meta:get_string('player_last_morph_status')
  if status ~= "none" and status ~= nil and status ~= "" then
    return status
  else
    return nil
  end
end

function morphinggrid.get_current_ranger_wear(player)
  local ranger = morphinggrid.registered_rangers[morphinggrid.get_morph_status(player)]
  if ranger ~= nil then
    local inv = minetest.get_inventory({
      type="detached", name=player:get_player_name().."_armor"})
      
    for k, v in pairs(inv:get_list("armor")) do
      if v:get_count() > 0 then
        return v:get_wear(), ranger
      end
    end
  end
  return nil, nil
end

--Morphing log
function morphinggrid.get_morphing_log()
  return morphinggrid.morphing_log
end

function morphinggrid.get_player_morphing_log(player)
  local t = {}
  for i, v in ipairs(morphinggrid.morphing_log) do
    if v.player:get_player_name() == player:get_player_name() then
      table.insert(t, v)
    end
  end
  return t
end