local storage = minetest.get_mod_storage()

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

-- support for i18n
armor_i18n = { }
armor_i18n.gettext, armor_i18n.ngettext = dofile(modpath.."/intllib.lua")

morphinggrid = {}
morphinggrid.mod_storage = {}

function morphinggrid.mod_storage.get_string(key)
  return storage:get_string(key)
end

function morphinggrid.mod_storage.set_string(key, value)
  storage:set_string(key, value)
end

dofile(minetest.get_modpath("morphinggrid") .. "/events.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/craftitems.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/energy_port.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/functions.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/connections.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/morphing.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/rangertype.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/ranger.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/weapons.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/privs.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/commands.lua")