function pr_villians.split_string(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  
  local t = {}
  if string.find(inputstr, sep) then
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
    end
  else
    table.insert(t, inputstr)
  end
  
  return t
end

function pr_villians.check_if_any_group(pos, groups)
  for i, v in ipairs(groups) do
    if minetest.get_item_group(minetest.get_node(pos).name, v) > 0 then
      return true
    end
  end
  return false
end

function pr_villians.get_pos_ahead(player, distance)
  local look_dir = player:get_look_dir()
  local pos = player:get_pos()
  
  return vector.new(pos.x + (distance * look_dir.x), (pos.y + 1) + (distance * look_dir.y), pos.z + (distance * look_dir.z))
end