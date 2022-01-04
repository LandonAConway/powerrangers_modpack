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
            settings.armor_wear = settings.armor_wear or 0
            if settings.armor_wear > 0 then
              settings.armor_wear = higher_to(settings.armor_wear - 219, 0)
            end
          end
        end
      end
    end
    --save connection properties
    morphinggrid.mod_storage.set_string(k.."_connection", minetest.serialize(v))
  end
end)

function morphinggrid.create_connection(ranger_name, player_name)
  morphinggrid.connections[ranger_name].players[player_name] = {}
  morphinggrid.connections[ranger_name].players[player_name].timer = 0
  morphinggrid.connections[ranger_name].players[player_name].in_use = false
  morphinggrid.connections[ranger_name].players[player_name].armor_wear = 0
end

function morphinggrid.get_connection(player, ranger)
	if type(ranger) == "table" then
		ranger = ranger.name
	end
	
	if type(player) ~= "string" then
		player = player:get_player_name()
	end
	
	morphinggrid.connections[ranger].players[player] = 
		morphinggrid.connections[ranger].players[player] or {
			timer = 0,
			wear = 0,
			in_use = false
		}
		
	local connection = morphinggrid.connections[ranger].players[player]
	return connection
end

function morphinggrid.configure_connection(ranger_name, player_name)
	morphinggrid.connections[ranger_name] = morphinggrid.connections[ranger_name] or { players = {} }
	local r = morphinggrid.connections[ranger_name]
	
	r.players[player_name] = r.players[player_name] or {}
	local p = r.players[player_name]
	
	p.timer = p.timer or 0
	p.armor_wear = p.armor_wear or 0
	if p.in_use == nil then p.in_use = false end
end

--save pos where died
minetest.register_on_dieplayer(function(player)
	local pos = player:get_pos()
	local pos_string = 
		"("..pos.x..", "..pos.y..", "..pos.z..")"
		
	local meta = player:get_meta()
	meta:set_string("griditem_savepos", pos_string)
end)

-- teleport player back after respawn
minetest.register_on_mods_loaded(function()
	minetest.register_on_respawnplayer(function(player)
		--save inventory to storage
		morphinggrid.morphers.save_inventory(player)
		
		--get other needed data
		local meta = player:get_meta()
		local pos = minetest.string_to_pos(meta:get_string("griditem_savepos"))
		
		--don't respawn player if conditions are met
		local _inv = morphinggrid.morphers.get_inventory(player)
		local cancel_respawn = false
		local item_desc = "Unknown"
		
		for i, stack in ipairs(_inv:get_list("main")) do
			local def = minetest.registered_items[stack:get_name()]
			if def ~= nil and item_is_valid(stack:get_name()) then
				if def.prevents_respawn then
					if def.allow_prevent_respawn(player, stack) then
						item_desc = def.description or stack:get_name()
						cancel_respawn = true
					end
				end
			end
		end
		
		local stack = _inv:get_stack("single", 1)
		local def = minetest.registered_items[stack:get_name()]
		if def ~= nil and item_is_valid(stack:get_name()) then
			if def.prevents_respawn then
				if def.allow_prevent_respawn(player, stack) then
					if not cancel_respawn then
						item_desc = def.description or stack:get_name()
					end
					cancel_respawn = true
				end
			end
		end
		
		local text
		if cancel_respawn then
			player:set_pos(pos)
		end
		
		local message = "You were not respawned because you were protected by a Grid Item. ("..item_desc..")"
		return cancel_respawn
	end)
end)

-- functions

function item_is_valid(itemstring)
	if morphinggrid.registered_griditems[itemstring] then
		return true
	elseif morphinggrid.registered_morphers[itemstring] then
		return true
	end
	
	return false
end

function higher_to(a, b)
  if a < b then
    return b
  end
  return a
end