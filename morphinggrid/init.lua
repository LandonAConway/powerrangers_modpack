local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

-- support for i18n
armor_i18n = { }
armor_i18n.gettext, armor_i18n.ngettext = dofile(modpath.."/intllib.lua")

morphinggrid = {}

dofile(minetest.get_modpath("morphinggrid") .. "/craftitems.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/energy_port.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/functions.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/morphing.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/privs.lua")
dofile(minetest.get_modpath("morphinggrid") .. "/commands.lua")