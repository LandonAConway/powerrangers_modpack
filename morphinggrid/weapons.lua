morphinggrid.registered_weapons = {}
morphinggrid.registered_firearms = {}

minetest.after(0, function()
  for _, _table in ipairs({minetest.registered_craftitems, minetest.registered_tools, minetest.registered_nodes}) do
    for k, v in pairs(_table) do
      if v.ranger_weapon then
        local weapondef = v.ranger_weapon
        weapondef.name = k
        weapondef.description = weapondef.description or v.description or "Unknown"
        
        if weapondef.ignore_requirments_on_can_summon == nil then weapondef.ignore_requirments_on_can_summon = true end
        
        morphinggrid.registered_weapons[weapondef.name] = weapondef
      end
    end
  end
end)

function morphinggrid.get_weapons(name)
  return morphinggrid.registered_weapons
end

function morphinggrid.get_weapon(name)
  return morphinggrid.registered_weapons[name]
end

local function get_weapon_keys(list)
  local t = {}
  for i, v in ipairs(list) do
    local weapon_key = morphinggrid.registered_weapons[v].weapon_key
    table.insert(t, weapon_key)
  end
  return t
end

local function get_weapon_items(weapon_name)
	local weapon = morphinggrid.registered_weapons[weapon_name]
	local t = {}
	for i, v in ipairs(weapon.items or {}) do
		t[v] = true
	end
	return weapon
end

local function has_weapon_item(player, weapon_name)
	local items = get_weapon_items(weapon_name)
	local inv = player:get_inventory()
	for _, i in pairs(inv:get_list("main")) do
		if items[i:get_name()] then
			return true
		end
	end
	for _, i in pairs(inv:get_list("morphers")) do
		if items[i:get_name()] then
			return true
		end
	end
	return false
end

local function get_ranger_weapons(ranger)
  local ranger_weapons = {}
  local rangerdef = morphinggrid.registered_rangers[ranger or ""]
  if rangerdef then
    for _, wepname in pairs(rangerdef.weapons or {}) do
      ranger_weapons[wepname] = true
    end
  end
  return ranger_weapons
end

local function get_required_weapons(weapon_name)
  local weapon = morphinggrid.registered_weapons[weapon_name]
  local required_weapons = {}
  for _, wepname in pairs(weapon.required_weapons or {}) do
    required_weapons[wepname] = true
  end
  return required_weapons
end

local function has_required_weapons(player, weapon_name)
  local inv = player:get_inventory()
  local inv_items = {}
  for _, stack in pairs(inv:get_list("main")) do
    inv_items[stack:get_name()] = true
  end
  local weapon = morphinggrid.registered_weapons[weapon_name] or {required_weapons={}}
  local count = 0
  for _, wepname in pairs(weapon.required_weapons or {}) do
    if not inv_items[wepname] then
      count = count + 1
    end
  end
  return count == 0
end

function morphinggrid.can_summon_weapon(player, weapon_name)
  local inv = player:get_inventory()
  local morph_status = morphinggrid.get_morph_status(player)
  local weapon = morphinggrid.registered_weapons[weapon_name]
  if type(weapon.can_summon) == "function" then
    if weapon.ignore_requirments_on_can_summon == true then
      return weapon.can_summon(player, morphinggrid.registered_rangers[morph_status])
    end
  else
    if get_ranger_weapons(morph_status)[weapon_name] or has_weapon_item(player, weapon_name) then
      if has_required_weapons(player, weapon_name) then
        local required_weapons = get_required_weapons(weapon_name)
        for _, stack in pairs(inv:get_list("main")) do
          if required_weapons[stack:get_name()] then
            inv:remove_item("main",stack)
          end
        end
        if type(weapon.can_summon) =="function" then
          return weapon.can_summon(player, morphinggrid.registered_rangers[morph_status])
        end
        return true
      end
      return false, "This is a combined weapon. You do not have the required weapons in your inventory to summon this weapon. "..
        "(Weapons: "..table.concat(get_weapon_keys(weapon.required_weapons), ", ")..")"
    end
  end
  return false
end

--Firearms
morphinggrid.firearms = {}

function morphinggrid.register_firearm(name, firearmdef)
  firearmdef.distance = firearmdef.distance or 20
  firearmdef.particle_texture = firearmdef.particle_texture or "morphinggrid_firearm_particle.png"
  local save_on_use = firearmdef.on_use
  firearmdef.on_use = function(itemstack, user, pointed_thing)
    local shot_successful, shot_results = morphinggrid.firearms.fire(user, firearmdef)
    
    if firearmdef.on_shot_fired ~= nil then
      firearmdef.on_shot_fired(itemstack, user, shot_results.pointed_thing, shot_successful)
    end
    if save_on_use ~= nil then
      save_on_use(itemstack, user, pointed_thing)
    end
  end
  
  morphinggrid.firearms[name] = firearmdef
  minetest.register_tool(name, firearmdef)
end

function morphinggrid.firearms.fire(player, firearm)
  if type(firearm) == "string" then
    firearm = morphinggrid.registered_firearms[firearm]
  end
  
  local pos = player:get_pos()
  local pos1 = morphinggrid.get_pos_ahead(player, 1)--{x=pos.x,y=pos.y,z=pos.z}
  local pos2 = morphinggrid.get_pos_ahead(player, firearm.distance)
  local found_pointed_thing = nil
  if firearm.particle_override ~= nil then
    local ranger = morphinggrid.registered_rangers[morphinggrid.get_morph_status(player)]
    firearm.particle_override(player, ranger)
  else
    morphinggrid.firearms.fire_particle(player, firearm, {x=pos1.x,y=pos1.y+1,z=pos1.z})
  end
  for pointed_thing in Raycast(pos1, pos2) do
    if pointed_thing and pointed_thing.type == "object" and pointed_thing.ref then
      if pointed_thing.ref:get_player_name() == player:get_player_name() then
        return false, { pointed_thing = pointed_thing }
      end
      pointed_thing.ref:punch(player, 1, firearm.tool_capabilities)
      found_pointed_thing = pointed_thing
      return true, { pointed_thing = pointed_thing }
    end
  end
  return false, { pointed_thing = found_pointed_thing }
end

function morphinggrid.firearms.fire_particle(player, firearm, pos)
  local look_dir = player:get_look_dir()
  local speed = 7
  minetest.add_particlespawner({
    amount = 100,
    time = 0.4,
    minpos = pos,
    maxpos = pos,
    minvel = {x=look_dir.x*speed,y=look_dir.y*speed,z=look_dir.z*speed},
    maxvel = {x=look_dir.x*speed,y=look_dir.y*speed,z=look_dir.z*speed},
    minacc = {x=look_dir.x*(speed/2),y=look_dir.y*(speed/2),z=look_dir.z*(speed/2)},
    maxacc = {x=look_dir.x*speed,y=look_dir.y*speed,z=look_dir.z*speed},
    minxptime = 15,
    maxxptime = 19,
    minsize = 1,
    maxsize = 3,
    collisiondetection = true,
    verticle = false,
    texture = firearm.particle_texture
  })
end