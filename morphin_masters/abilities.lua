local add_velocity = function(player, vel)
	player:add_velocity(vel)
end

morphinggrid.register_on_player_control(function(player, pos, ctrl)
    local morph_status = morphinggrid.get_morph_status(player)
	local morphin_masters = {
		["morphin_masters:green"] = true,
		["morphin_masters:white"] = true,
		["morphin_masters:black"] = true,
		["morphin_masters:pink"] = true,
		["morphin_masters:blue"] = true,
		["morphin_masters:yellow"] = true,
		["morphin_masters:red"] = true,
		["morphin_masters:silver"] = true,
		["morphin_masters:gold"] = true
	}
	
	--up, down, left, right, jump, aux1, sneak, dig, place, zoom
	if morphin_masters[morph_status] then
		if ctrl.aux1 and ctrl.LMB then
			local vel = player:get_player_velocity()
			if vel.x < 32 and vel.z < 32 then
				add_velocity(player, {x = vel.x*0.8, y = 0, z = vel.y*0.8})
			end
		end
		
		if ctrl.sneak and ctrl.RMB then
			local vel = player:get_player_velocity()
			if vel.y < 0 then
				add_velocity(player, {x = 0, y = (0-vel.y)*0.5, z = 0})
			end
		end
		
		if ctrl.LMB and ctrl.RMB then
			local look_dir = player:get_look_dir()
			add_velocity(player, {x = look_dir.x*5, y = look_dir.y*5, z = look_dir.z*5})
		end
		
		if not ctrl.LMB and ctrl.RMB then
			local oldpos = minetest.string_to_pos(player:get_meta():get_string("pr_jump_pos"))
			if oldpos ~= nil then
				if pos.y > oldpos.y + 0.3 then
					add_velocity(player, {x=0,y=3.5,z=0})
				elseif get_node_name(vector.new(pos.x, pos.y-1, pos.z)) == "air" or is_node_group(vector.new(pos.x, pos.y-1, pos.z), "water") then
					add_velocity(player, {x=0,y=3.5,z=0})
				end
			end
		elseif ctrl.right or ctrl.left or ctrl.up or ctrl.down then
			player:get_meta():set_string("pr_jump_pos", minetest.pos_to_string(pos))
		end
		
		if ctrl.LMB and ctrl.sneak then
			local capabilities = {
				full_punch_interval = 0.0,
				max_drop_level=1,
				damage_groups = {fleshy=5},
			}

			local objects = minetest.get_objects_inside_radius(pos, 8)
			for _, obj in ipairs(objects) do
				if obj:is_player() then
					if obj:get_player_name() ~= player:get_player_name() then
						obj:punch(player, 1, capabilities)
					end
				else
					obj:punch(player, 1, capabilities)
				end
			end
		end
	end
end)

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