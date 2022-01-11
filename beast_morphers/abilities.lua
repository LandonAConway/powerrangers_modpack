morphinggrid.register_on_player_control(function(player, pos, ctrl)
  local morph_status = morphinggrid.get_morph_status(player)
  if morph_status == "beast_morphers:red" then
    if ctrl.aux1 then
      local vel = player:get_player_velocity()
      if vel.x < 31 and vel.z < 31 then
        player:add_player_velocity({x = vel.x * 1, y = 0, z = vel.z * 1})
      end
    end
  elseif morph_status == "beast_morphers:yellow" then
    if ctrl.RMB then
      local oldpos = minetest.string_to_pos(player:get_meta():get_string("bm_jump_pos"))
      if oldpos ~= nil then
        if pos.y > oldpos.y + 0.3 then
          player:add_player_velocity({x=0,y=2.5,z=0})
        elseif get_node_name(vector.new(pos.x, pos.y-1, pos.z)) == "air" or is_node_group(vector.new(pos.x, pos.y-1, pos.z), "water") then
          player:add_player_velocity({x=0,y=2.5,z=0})
        end
      end
    elseif ctrl.right or ctrl.left or ctrl.up or ctrl.down then
      player:get_meta():set_string("bm_jump_pos", minetest.pos_to_string(pos))
    end
--  elseif morph_status == "beast_morphers:blue" then
--    if ctrl.LMB then
--      local capabilities = {
--        full_punch_interval = 0.0,
--        max_drop_level=1,
--        groupcaps={
--          snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=1, maxlevel=3},
--        },
--        damage_groups = {fleshy=100},
--      }
--      
--      local objects = minetest.get_objects_inside_radius(pos, 5)
--      for _, obj in ipairs(objects) do
--        if obj:is_player() then
--          if obj:get_player_name() ~= player:get_player_name() then
--            obj:punch(player, 1, capabilities)
--          end
--        else
--          obj:punch(player, 1, capabilities)
--        end
--      end
--    end
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