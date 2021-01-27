communicator = {}
communicator.registered_communicators = {}

dofile(minetest.get_modpath("communicator") .. "/privs.lua")
dofile(minetest.get_modpath("communicator") .. "/commands.lua")
dofile(minetest.get_modpath("communicator") .. "/teleportation.lua")
dofile(minetest.get_modpath("communicator") .. "/communicators.lua")