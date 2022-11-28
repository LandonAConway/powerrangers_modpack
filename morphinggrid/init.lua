local storage = minetest.get_mod_storage()

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

morphinggrid = {}
morphinggrid.optional_dependencies = {
  ["3d_armor"] = minetest.get_modpath("3d_armor") ~= nil,
  ["electronic_materials"] = minetest.get_modpath("electronic_materials") ~= nil,
  ["hudbars"] = minetest.get_modpath("hudbars") ~= nil
}

morphinggrid.default_callbacks = {}
morphinggrid.mod_storage = {}

function morphinggrid.mod_storage.get_string(key)
  return storage:get_string(key)
end

function morphinggrid.mod_storage.set_string(key, value)
  storage:set_string(key, value)
end

dofile(minetest.get_modpath("morphinggrid") .. "/events.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/functions.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/folders.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/hudbars.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/ranger_data.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/ranger_armor.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/morphing.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/grid_items.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/morpher_slots.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/ranger.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/weapons.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/powerups.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/privs.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/commands.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/morphers_inv.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/craftitems.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/crafting.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/energy_port.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/rangerdata_maker.lua")