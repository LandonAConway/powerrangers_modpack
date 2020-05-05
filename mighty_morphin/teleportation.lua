teleportation = {}

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
		local pos = player:get_pos()
		local meta = player:get_meta()
		meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))
		
		local to_pos = minetest.string_to_pos(text)
		
		if to_pos ~= nil then
			teleportation.teleport(player, to_pos)
			return true, "Teleported to: "..minetest.pos_to_string(to_pos)
		else
			return false, "Position is not a valid."
		end
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
		local pos = player:get_pos()
		local meta = player:get_meta()
		meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))
		
		local to_pos = teleportation.locations_get_pos(player, text)
		
		if text ~= nil and teleportation.locations_exists(player, text) then
			teleportation.teleport(player, to_pos)
			return true, "Teleported to: "..minetest.pos_to_string(to_pos)
		else
			return false, "Position key does not exist."
		end
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
		local pos = player:get_pos()
		local meta = player:get_meta()
		
		if minetest.player_exists(text) then
			for _, plr in ipairs(minetest.get_connected_players()) do
				if text == plr:get_player_name() then
					local to_pos = plr:get_pos()
					meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))
					
					local best_pos = teleportation.find_best_pos(to_pos, 7)
					if best_pos ~= nil then
						player:set_pos(best_pos)
						return true, "Teleported to: "..minetest.pos_to_string(best_pos)
					else
						return false, "There is not enough space for teleportation."
					end
				end
			end
			
			return false, "Player is not online."
		else
			return false, "Player does not exist."
		end
	end,
})

minetest.register_chatcommand("cmc_teleportback", {
	params = "",
	description = "Teleports player back to previous position.",
	
	privs = {
		interact = true,
		power_rangers = true,
		communicator = true,
	},
	
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local meta = player:get_meta()
		
		local pos = minetest.string_to_pos(meta:get_string("cmc_last_pos"))
		
		if pos ~= nil then
			meta:set_string("cmc_last_pos", minetest.pos_to_string(player:get_pos()))
			teleportation.teleport(player, pos)
			return true, "Teleported to: "..minetest.pos_to_string(pos)
		else
			return false, "No position set"
		end
	end,
})

minetest.register_chatcommand("cmc_teleportation_get_pos", {
	params = "<key>",
	description = "Gets location of specified key.",
	
	privs = {
		interact = true,
		power_rangers = true,
		communicator = true,
	},
	
	func = function(name, text)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()
		
		local to_pos = teleportation.locations_get_pos(player, text)
		
		if text ~= nil and teleportation.locations_exists(player, text) then
			return true, "'"..text.."' = "..minetest.pos_to_string(to_pos)
		else
			return false, "Position key does not exist."
		end
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
		local pos = player:get_pos()
		local meta = player:get_meta()
		
		if text ~= nil and text ~= "" then
			if not string.find(text, "|") and not string.find(text, "=") then
				teleportation.locations_add_pos(player, pos, text)
				return true, "'"..text.."' added. "
			else
				return false, "Key cannot contain these characters: '|='."
			end
		else
			return false, "Enter a key."
		end
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
		local pos = player:get_pos()
		local meta = player:get_meta()
		
		if text ~= nil and text ~= "" then
			if not string.find(text, "|") and not string.find(text, "=") then
				teleportation.locations_remove_pos(player, text)
				return true, "'"..text.."' removed. "
			else
				return false, "Key cannot contain these characters: '|='."
			end
		else
			return false, "Enter a key."
		end
	end,
})

function teleportation.teleport(player, pos)
	player:set_pos(pos)
end

function teleportation.locations_add_pos(player, pos, key)
	local meta = player:get_meta()
	local list = meta:get_string("cmc_locations_list")
	if list ~= nil or list ~= "" then
		local list_table = splitstr(list, "|")
		if teleportation.locations_exists(player, key) == true then
			list_table = teleportation.table_remove_pos(list_table, key)
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

function teleportation.locations_remove_pos(player, key)
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

function teleportation.table_remove_pos(t, key)
	for i, v in ipairs(t) do
		if string.find(v, key.."=") then
			table.remove(t, i)
		end
	end
	
	return t
end

function teleportation.locations_get_pos(player, key)
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

function teleportation.locations_exists(player, key)
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

function teleportation.get_node_positions_inside_area(pos, span)
	local first = vector.new(pos.x + span, pos.y + span, pos.z + span)
	local last = vector.new(pos.x - span, pos.y - span, pos.z - span)
	return teleportation.add_pos(first, vector.new(first.x, first.y, first.z), last)
end

function teleportation.add_pos(first_pos, current_pos, last_pos, list)
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

function teleportation.find_best_pos(pos, radius)
	local positions = teleportation.get_node_positions_inside_area(pos, radius)
	for _, pos in ipairs(positions) do
		local node = minetest.get_node(pos)
		local node_above = minetest.get_node(vector.new(pos.x, pos.y + 1, pos.z))
		local node_below = minetest.get_node(vector.new(pos.x, pos.y - 1, pos.z))
		if node.name == "air" and node_above.name == "air" then
			if minetest.get_item_group(node_below.name, "cracky") > 0 or
			minetest.get_item_group(node_below.name, "crumbly") > 0 or
			minetest.get_item_group(node_below.name, "choppy") > 0 or
			minetest.get_item_group(node_below.name, "snappy") > 0 or
			minetest.get_item_group(node_below.name, "snowy") > 0 or
			minetest.get_item_group(node_below.name, "water") > 0 then
				return pos
			end
		elseif minetest.get_item_group(node.name, "water") > 0 and minetest.get_item_group(node_above.name, "water") > 0 then
			if minetest.get_item_group(node_below.name, "cracky") > 0 or
			minetest.get_item_group(node_below.name, "crumbly") > 0 or
			minetest.get_item_group(node_below.name, "choppy") > 0 or
			minetest.get_item_group(node_below.name, "snappy") > 0 or
			minetest.get_item_group(node_below.name, "snowy") > 0 or
			minetest.get_item_group(node_below.name, "water") > 0 then
				return pos
			end
		end
	end
	return nil
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