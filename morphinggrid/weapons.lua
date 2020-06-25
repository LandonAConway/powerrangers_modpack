morphinggrid.registered_weapons = {}

minetest.after(0, function()
  for _, _table in ipairs({minetest.registered_craftitems, minetest.registered_tools, minetest.registered_nodes}) do
    for k, v in pairs(_table) do
      if v.ranger_weapon then
        local weapondef = v.ranger_weapon
        weapondef.name = k
        weapondef.description = weapondef.description or v.description or "Unknown"
        
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

function morphinggrid.can_summon_weapon(player, weapon_name)
  local morph_status = morphinggrid.get_morph_status(player)
  local weapon = morphinggrid.registered_weapons[weapon_name]
  if weapon.can_summon then
    local ranger = morphinggrid.get_ranger(morph_status)
    return weapon.can_summon(player, ranger)
  else
    for i, v in ipairs(weapon.rangers) do
      if v == morph_status then
        return true
      end
    end
  end
  return false
end