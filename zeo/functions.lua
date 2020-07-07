function zeo.player_has_item(player, item)
  local inv = player:get_inventory()
  local stack = ItemStack(item.." 1")
  local result = false
  if inv:contains_item("main", stack) == true or inv:contains_item("morphers", stack) == true then
    result = true
  end
  return result
end

function is_node_group(pos, group)
  if minetest.get_item_group(get_node_name(pos), group) > 0 then
    return true
  end
  return false
end

function get_node_name(pos)
  local node = minetest.get_node(pos)
  return node.name
end