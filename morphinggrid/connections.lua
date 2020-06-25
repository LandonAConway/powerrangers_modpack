morphinggrid.connections = {}

function morphinggrid.get_connection(name)
  return morphinggrid.connections[name]
end

local second_timer = 0

minetest.register_globalstep(function(dtime)
  for k, v in pairs(morphinggrid.connections) do
    for player_name, settings in pairs(v.players) do
      --damaged connection
      if settings.timer > 0 then
        settings.timer = settings.timer - dtime
      end
      
      --only about update every second
      second_timer = second_timer + dtime
      if second_timer > 1 then
        second_timer = 0
        
        --do all things here that update every second
        
        --update armor wear
        if settings.timer < 1 then
          if not settings.in_use then
            if settings.armor_wear > 0 then
              settings.armor_wear = higher_to(settings.armor_wear - 219, 0)
            end
          end
        end
      end
    end
    --save connection properties
    morphinggrid.mod_storage.set_string(v.name.."_connection", minetest.serialize(v))
  end
end)

function morphinggrid.create_connection(ranger_name, player_name)
  morphinggrid.connections[ranger_name].players[player_name] = {}
  morphinggrid.connections[ranger_name].players[player_name].timer = 0
  morphinggrid.connections[ranger_name].players[player_name].in_use = false
  morphinggrid.connections[ranger_name].players[player_name].armor_wear = 0
end

function higher_to(a, b)
  if a < b then
    return b
  end
  return a
end