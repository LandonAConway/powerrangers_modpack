function morphinggrid.get_before_pointed_pos(player, max_distance)
  local prevent_nil = nil
  local result = nil
  for i = 0, max_distance do
    local pos = morphinggrid.get_pos_ahead(player, i)
    prevent_nil = pos
    if minetest.get_node(pos).name ~= "air" and minetest.get_node(pos).name ~= "default:water_source" and minetest.get_node(pos).name ~= "default:water_flowing" then
      return result
    end
    result = pos
  end
  return prevent_nil
end

function morphinggrid.get_pos_ahead(player, distance)
  local look_dir = player:get_look_dir()
  local pos = player:get_pos()
  
  return vector.new(pos.x + (distance * look_dir.x), (pos.y + 1) + (distance * look_dir.y), pos.z + (distance * look_dir.z))
end

function morphinggrid.split_string (inputstr, sep)
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

function morphinggrid.seconds_to_clock(seconds)
  if seconds <= 0 then
    return "00:00:00"
  else
    local days_ = math.floor(seconds/86400)
    seconds = seconds - days_ * 86400
    local hours_ = math.floor(seconds / 3600)
    seconds = seconds - hours_ * 3600
    local minutes_ = math.floor(seconds / 60)
    seconds = seconds - minutes_ * 60
    local seconds_ = seconds
    
    return {days = days_, hours = hours_, minutes = minutes_, seconds = seconds_}
  end
end

function if_any_of_nodes(pos, nodes)
  for i, v in ipairs(nodes) do
    if minetest.get_node(pos).name == v then
      return true
    end
  end
  return false
end