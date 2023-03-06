communicator.cmd_presets.teleportation = {}

communicator.teleportation = {}

communicator.cmd_presets.teleportation.teleport_pos = {
    short = "telp",
    params = "<pos> (x,y,z)",
    description = "Teleports player to specified position.",

    privs = {
        interact = true,
        power_rangers = true,
        communicator = true
    },

    func = function(name, text)
        local player = minetest.get_player_by_name(name)

        if communicator.player_has_communicator(player) then
            local cmc = communicator.registered_communicators[communicator.get_inventory(player):get_stack("single", 1)
                :get_name()]

            local pos = player:get_pos()
            local meta = player:get_meta()

            local to_pos = minetest.string_to_pos(text)

            if to_pos ~= nil then
                meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))

                local old_pos = pos;
                local new_pos = to_pos;
                local result, message = true, "Teleported to: " .. minetest.pos_to_string(to_pos)

                if cmc.before_teleport ~= nil then
                    result, message = cmc.before_teleport(player, old_pos, new_pos, false)
                end

                if result then
                    communicator.teleportation.teleport(player, to_pos)

                    if cmc.after_teleport ~= nil then
                        cmc.after_teleport(player, old_pos, new_pos, false)
                    end
                end

                return result, message -- , stack
            end
            return false, "Position is not a valid."
        end
        return false, "You do not have a communicator in the communicator slot."
    end
}

communicator.cmd_presets.teleportation.safe_teleport_pos = {
    short = "telsp",
    params = "<pos> (x,y,z)",
    description = "Safely teleports player near specified position. If the position is in a dangorous spot (i.e. in free fall) you will be teleported to a safe position near it.",

    privs = {
        interact = true,
        power_rangers = true,
        communicator = true
    },

    func = function(name, text)
        local player = minetest.get_player_by_name(name)

        if communicator.player_has_communicator(player) then
            local cmc = communicator.registered_communicators[communicator.get_inventory(player):get_stack("single", 1)
                :get_name()]

			local pos = player:get_pos()
			local meta = player:get_meta()
			local origin = minetest.string_to_pos(text)

			if origin then
				local safe = communicator.teleportation.get_safe_position(origin, 15)
				if safe then
					local result, message = true, "Teleported to: " .. minetest.pos_to_string(safe)
					if cmc.before_teleport ~= nil then
						result, message = cmc.before_teleport(player, pos, safe, false)
					end
					if result then
						meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))
						player:set_pos(safe)
						if cmc.after_teleport ~= nil then
							cmc.after_teleport(player, pos, safe, false)
						end
					end
					return result, message
				end
				return false, "Could not find a safe position for teleportation."
			end
			return false, "Please enter a valid position."
        end
        return false, "You do not have a communicator in the communicator slot."
    end
}

communicator.cmd_presets.teleportation.teleport = {
    short = "tel",
    params = "<key>",
    description = "Teleports player to position associated with the given key.",

    privs = {
        interact = true,
        power_rangers = true,
        communicator = true
    },

    func = function(name, text)
        local player = minetest.get_player_by_name(name)

        if communicator.player_has_communicator(player) then
            local cmc = communicator.registered_communicators[communicator.get_inventory(player):get_stack("single", 1)
                :get_name()]

            local pos = player:get_pos()
            local meta = player:get_meta()
            local smeta = communicator.get_inventory(player):get_stack("single", 1):get_meta()

            -- proposed--
            local positions = minetest.deserialize(smeta:get_string("positions")) or {}
            if positions[text] ~= nil then
                local old_pos = pos;
                local new_pos = positions[text];
                local result, message = true, "Teleported to: " .. minetest.pos_to_string(positions[text])

                if cmc.before_teleport ~= nil then
                    result, message = cmc.before_teleport(player, old_pos, new_pos, false)
                end

                -- teleport player
                if result then
                    meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))
                    player:set_pos(positions[text])

                    if cmc.after_teleport ~= nil then
                        cmc.after_teleport(player, old_pos, new_pos, false)
                    end
                end

                return result, message -- , stack
            end
            return false, "Position key does not exist."
        end
        return false, "You do not have a communicator in the communicator slot."
    end
}

communicator.cmd_presets.teleportation.teleport_to_player = {
    short = "telpl",
    params = "<player>",
    description = "Teleports player to specified player.",

    privs = {
        interact = true,
        power_rangers = true,
        communicator = true
    },

    func = function(name, text)
        local player = minetest.get_player_by_name(name)

        if communicator.player_has_communicator(player) then
            local cmc = communicator.registered_communicators[communicator.get_inventory(player):get_stack("single", 1)
                :get_name()]

            local pos = player:get_pos()
            local meta = player:get_meta()

			local target = minetest.get_player_by_name(text)
			if target then
				local origin = target:get_pos()
				local safe = communicator.teleportation.get_safe_position(origin, 15, 0.95)
				if safe then
					local result, message = true, "Teleported to: " .. minetest.pos_to_string(safe)
					if cmc.before_teleport ~= nil then
						result, message = cmc.before_teleport(player, pos, safe, false)
					end
					if result then
						meta:set_string("cmc_last_pos", minetest.pos_to_string(pos))
						player:set_pos(safe)
						if cmc.after_teleport ~= nil then
							cmc.after_teleport(player, pos, safe, false)
						end
					end
					return result, message
				end
				return false, "Could not find a safe position for teleportation."
			end
			return false, "Player is not online or does not exist."
        end
        return false, "You do not have a communicator in the communicator slot."
    end
}

communicator.cmd_presets.teleportation.teleport_back = {
    short = "telb",
    params = "",
    description = "Teleports player back to previous position.",

    privs = {
        interact = true,
        power_rangers = true,
        communicator = true
    },

    func = function(name, param)
        local player = minetest.get_player_by_name(name)

        if communicator.player_has_communicator(player) then
            local cmc = communicator.registered_communicators[communicator.get_inventory(player):get_stack("single", 1)
                :get_name()]

            local meta = player:get_meta()

            local pos = minetest.string_to_pos(meta:get_string("cmc_last_pos"))

            if pos ~= nil then
                local old_pos = player:get_pos();
                local new_pos = pos;
                local result, message = true, "Teleported to: " .. minetest.pos_to_string(pos)

                if cmc.before_teleport ~= nil then
                    result, message = cmc.before_teleport(player, old_pos, new_pos, false)
                end

                -- teleport player
                if result then
                    meta:set_string("cmc_last_pos", minetest.pos_to_string(player:get_pos()))
                    communicator.teleportation.teleport(player, pos)

                    if cmc.after_teleport ~= nil then
                        cmc.after_teleport(player, old_pos, new_pos, true)
                    end
                end

                return result, message -- , stack
            end
            return false, "No position set"
        end
        return false, "You do not have a communicator in the communicator slot."
    end
}

communicator.cmd_presets.teleportation.teleportation_add_pos = {
    short = "telad",
    params = "<key>",
    description = "Saves players current location with specified key so it can be teleported to.",

    privs = {
        interact = true,
        power_rangers = true,
        communicator = true
    },

    func = function(name, text)
        local player = minetest.get_player_by_name(name)

        if communicator.player_has_communicator(player) then
            local cmc = communicator.registered_communicators[communicator.get_inventory(player):get_stack("single", 1)
                :get_name()]

            local pos = player:get_pos()
            local meta = player:get_meta()
            local stack = communicator.get_inventory(player):get_stack("single", 1)
            local smeta = stack:get_meta()

            if text ~= nil and text ~= "" then
                if not string.find(text, "|") and not string.find(text, "=") then
                    -- proposed--
                    local positions = minetest.deserialize(smeta:get_string("positions")) or {}
                    positions[text] = pos
                    smeta:set_string("positions", minetest.serialize(positions))
                    communicator.get_inventory(player):set_stack("single", 1, stack)
                    return true, "'" .. text .. "' added. ", stack
                end
                return false, "Key cannot contain these characters: '|='."
            end
            return false, "Enter a key."
        end
        return false, "You do not have a communicator in the communicator slot."
    end
}

communicator.cmd_presets.teleportation.teleportation_remove_pos = {
    short = "telre",
    params = "<key>",
    description = "Deletes location by specified key.",

    privs = {
        interact = true,
        power_rangers = true,
        communicator = true
    },

    func = function(name, text)
        local player = minetest.get_player_by_name(name)

        if communicator.player_has_communicator(player) then
            local cmc = communicator.registered_communicators[communicator.get_inventory(player):get_stack("single", 1)
                :get_name()]

            local pos = player:get_pos()
            local meta = player:get_meta()
            local stack = communicator.get_inventory(player):get_stack("single", 1)
            local smeta = stack:get_meta()

            if text ~= nil and text ~= "" then
                -- proposed--
                local positions = minetest.deserialize(smeta:get_string("positions")) or {}

                if positions[text] ~= nil then
                    positions[text] = nil
                    smeta:set_string("positions", minetest.serialize(positions))
                    return true, "'" .. text .. "' removed.", stack
                end
                return false, "Key does not exist."
            end
            return false, "Enter a key."
        end
        return false, "You do not have a communicator in the communicator slot."
    end
}

communicator.cmd_presets.teleportation.teleportation_get_keys = {
    short = "telkeys",
    params = "",
    description = "Lists all of your keys.",

    privs = {
        interact = true,
        power_rangers = true,
        communicator = true
    },

    func = function(name, text)
        local player = minetest.get_player_by_name(name)

        if communicator.player_has_communicator(player) then
            local cmc = communicator.registered_communicators[communicator.get_inventory(player):get_stack("single", 1)
                :get_name()]

            -- proposed--
            local pos = player:get_pos()
            local meta = player:get_meta()
            local stack = communicator.get_inventory(player):get_stack("single", 1)
            local smeta = stack:get_meta()
            local positions = minetest.deserialize(smeta:get_string("positions")) or {}

            local keys;

            for k, p in pairs(positions) do
                if keys == nil then
                    keys = ""
                end
                keys = keys .. k .. ", (" .. p.x .. ", " .. p.y .. ", " .. p.z .. ") \n"
            end

            if keys ~= nil then
                return true, keys, stack
            end
            return false, "You have do not have any saved positions."
        end
        return false, "You do not have a communicator in the communicator slot."
    end
}

communicator.cmd_presets.teleportation.teleportation_get_pos = {
    short = "telgp",
    params = "<key>",
    description = "Shows location by specified key.",

    privs = {
        interact = true,
        power_rangers = true,
        communicator = true
    },

    func = function(name, text)
        local player = minetest.get_player_by_name(name)

        if communicator.player_has_communicator(player) then
            local cmc = communicator.registered_communicators[communicator.get_inventory(player):get_stack("single", 1)
                :get_name()]

            local pos = player:get_pos()
            local meta = player:get_meta()

            if text ~= nil and text ~= "" then
                -- proposed--
                local pos = player:get_pos()
                local meta = player:get_meta()
                local stack = communicator.get_inventory(player):get_stack("single", 1)
                local smeta = stack:get_meta()
                local positions = minetest.deserialize(smeta:get_string("positions")) or {}

                if positions[text] ~= nil then
                    return true, "Position of '" .. text .. "' is: " .. minetest.pos_to_string(positions[text]), stack
                end
                return false, "Key does not exist."
            end
            return false, "Enter a key."
        end
        return false, "You do not have a communicator in the communicator slot."
    end
}

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
            table.insert(list_table, key .. "=" .. minetest.pos_to_string(pos))
        else
            table.insert(list_table, key .. "=" .. minetest.pos_to_string(pos))
        end

        meta:set_string("cmc_locations_list", table.concat(list_table, "|"))
        return true
    else
        meta:set_string("cmc_locations_list", key .. "=" .. minetest.pos_to_string(pos))
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
            if string.find(v, key .. "=") then
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
        if string.find(v, key .. "=") then
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
        if string.find(v, key .. "=") then
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
        if string.find(v, key .. "=") then
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
    if list == nil then
        list = {}
    end

    local x_amount = first_pos.x - last_pos.x + 1
    local y_amount = first_pos.y - last_pos.y + 1
    local z_amount = first_pos.z - last_pos.z + 1

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

function communicator.teleportation.get_safe_position(origin, radius, min_distance_from_origin)
    min_distance_from_origin = min_distance_from_origin or 0
	local positions = {}
	local c = 0
	for x=-radius, radius do
		for y=-radius, radius do
			for z=-radius, radius do
				local pos = vector.offset(origin, x, y, z)
				table.insert(positions, pos)
				c = c + 1
			end
		end
	end
	table.sort(positions, function(a, b)
		return vector.distance(a, origin) < vector.distance(b, origin)
	end)
	minetest.load_area(positions[1], positions[c])
	for _, pos in pairs(positions) do
        --we must load the node under since it may not be included in the list
        minetest.load_area(vector.offset(pos, 0, -1, 0), vector.offset(pos, 0, -1, 0))
		local node_under = minetest.get_node(vector.offset(pos, 0, -1, 0))
        local node_under_def = minetest.registered_nodes[node_under.name]
		local node_y0 = minetest.get_node(pos)
		local node_y1 = minetest.get_node(vector.offset(pos, 0, 1, 0))
		if node_under.name ~= "air"
        and node_under_def.liquidtype ~= "source"
        and node_under_def.liquidtype ~= "flowing"
		and node_y0.name == "air"
		and node_y1.name == "air"
		and vector.distance(origin, pos) > min_distance_from_origin then
			return pos
		end
	end
end

function communicator.teleportation.get_players_near(pos, radius)
    local objs = minetest.get_objects_inside_radius(pos, radius * 2)
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
    for str in string.gmatch(input, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end
