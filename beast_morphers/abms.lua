minetest.register_abm({
  nodenames = { "beast_morphers:neuro_transmitter"},
  interval = 5,
  chance = 1,
  action = function(pos)
    if minetest.get_node(vector.new(pos.x, pos.y+1, pos.z)).name == "mesecons_extrawires:mese_powered" then
      for i_, node_pos in ipairs(beast_morphers.get_nodes_under(pos, 5)) do
        for _, obj in ipairs(minetest.get_objects_inside_radius(node_pos, 1)) do
          if obj:is_player() then
            local inv = minetest.get_inventory({type = "node", pos = pos})
            local stack = inv:get_stack("morphx", 1)
            if stack:get_name() == "beast_morphers:morphx_drum" then
              if stack:get_meta():get_string("morphx_amount") ~= nil and stack:get_meta():get_string("morphx_amount") ~= "" then
                if tonumber(stack:get_meta():get_string("morphx_amount")) > 198 then
                  for _i, v in ipairs({{"dna_cheetah", "red"}, {"dna_jack_rabbit", "yellow"}, {"dna_gorilla", "blue"}, {"dna_mantis", "gold"}, {"dna_scarab_beetle", "silver"}}) do
                    if obj:get_wielded_item():get_name() == "beast_morphers:"..v[1] then
                      if morphinggrid.get_morph_status(obj) == nil then
                        local dna = obj:get_meta():get_string("bm_dna_"..v[2])
                        if dna == nil or dna == "" or dna == "false" then
                          obj:get_meta():set_string("bm_dna_"..v[2], "true")
                          local ranger = morphinggrid.get_ranger("beast_morphers:"..v[2])
                          morphinggrid.morph(obj, ranger)
                          inv:remove_item("morphx", ItemStack("beast_morphers:morphx_drum"))
                          obj:set_wielded_item(ItemStack("beast_morphers:test_tube_empty"))
                          minetest.chat_send_player(obj:get_player_name(), "Your DNA has been combined. You can now morph into the "..v[2].." ranger.")
                          return true
                        else
                          obj:get_meta():set_string("bm_dna_"..v[2], "false")
                          minetest.chat_send_player(obj:get_player_name(), "Your DNA has been separated. You can now morph into the "..v[2].." ranger.")
                          return true
                        end
                      end
                    end
                  end
                  minetest.chat_send_player(obj:get_player_name(), "Sequence failed. You must be holding the dna you want to combine with or separate from.")
                return false
                end
              end
            end
            minetest.chat_send_player(obj:get_player_name(), "Sequence failed. Neuro Transmitter has no Morph-X supply.")
            return false
          end
        end
      end
    end
  end
})

function beast_morphers.get_nodes_under(pos, amount)
  local result = {}
  for i = 1, amount do
    table.insert(result, vector.new(pos.x, pos.y - i, pos.z))
  end
  return result
end