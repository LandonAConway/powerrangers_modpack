communicator = {}
communicator.cmd_presets = {}
communicator.registered_channels = {}
communicator.registered_communicators = {}

dofile(minetest.get_modpath("communicator") .. "/privs.lua")
dofile(minetest.get_modpath("communicator") .. "/commands.lua")
dofile(minetest.get_modpath("communicator") .. "/cmd_presets/presets.lua")
dofile(minetest.get_modpath("communicator") .. "/channels.lua")
dofile(minetest.get_modpath("communicator") .. "/communicators.lua")