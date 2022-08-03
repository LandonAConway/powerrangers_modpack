morphinggrid.registered_player_controls = {}

morphinggrid.register_on_player_control = function(fn)
  table.insert(morphinggrid.registered_player_controls, fn)
end

minetest.register_globalstep(function(dtime)
  local players = minetest.get_connected_players()
  for _, player in pairs(players) do
    local pos = player:get_pos()
    local ctrl = player:get_player_control()
    for k, fn in pairs(morphinggrid.registered_player_controls) do
      fn(player, pos, ctrl)
    end
  end
end)