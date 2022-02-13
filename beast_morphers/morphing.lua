function beast_morphers.morph(player, itemstack)
  local key, message = beast_morphers.can_morph(player)--beast_morphers.check_for_key(player)
  if key ~= nil then
    morphinggrid.morph(player, morphinggrid.get_ranger("beast_morphers:"..key), { morpher = "beast_morphers:morpher", itemstack = itemstack})
  else
    minetest.chat_send_player(player:get_player_name(), message)
  end
end

function beast_morphers.can_morph(player)
  local wielded_item = player:get_wielded_item()
  local next_item = player:get_inventory():get_stack(player:get_wield_list(), player:get_wield_index()+1)
  local morphers_first_item = morphinggrid.morphers.get_inventory(player):get_stack("main",1)
  local is_key_1 = minetest.get_item_group(morphers_first_item:get_name(), "bm_key")
  local is_key_2 = minetest.get_item_group(next_item:get_name(),  "bm_key")
  if is_key_1 > 0 then
    local requested_key = morphers_first_item:get_name():gsub("beast_morphers:morpher_key_", "")
    local ranger = morphinggrid.registered_rangers["beast_morphers:"..requested_key]
    if player:get_meta():get_string("bm_dna_"..requested_key) == "true" then
      if morphers_first_item:get_wear() < 58981 then
        morphers_first_item:add_wear(6553.5)
        morphinggrid.morphers.set_stack(player, 1, morphers_first_item)
        return requested_key, ""
      else
        return nil, "Key needs more Morph-X."
      end
    end
    return nil, "You do not have the correct dna to morph into the "..ranger.description
  elseif wielded_item:get_name() == "beast_morphers:morpher" and is_key_2 > 0 then
    local requested_key = next_item:get_name():gsub("beast_morphers:morpher_key_", "")
    local ranger = morphinggrid.registered_rangers["beast_morphers:"..requested_key]
    if player:get_meta():get_string("bm_dna_"..requested_key) == "true" then
      if next_item:get_wear() < 58981 then
        next_item:add_wear(6553.5)
        player:get_inventory():set_stack(player:get_wield_list(), player:get_wield_index()+1, next_item)
        return requested_key, ""
      else
        return nil, "Key needs more Morph-X."
      end
    end
    return nil, "You do not have the correct dna to morph into the "..ranger.description
  end
  return nil, "Please place a morpher key next to your morpher or in the first slot of your morpher collection. Use chat command '/morphers'"
end